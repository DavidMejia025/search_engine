require_relative "../services/logs/"
require_relative "./indexer/factory_indexer"
require_relative "../queue/factory_queue"
require_relative "./parser/html_parser"
require_relative "./dao/web_page_dao"
require_relative "./dao/links_table_dao"
require_relative "./data_structures/web_page"
require_relative "./data_structures/linked_page"
require_relative "../repository/factory_repository"

require 'httparty'
require "nokogiri"

class Engine
  def initialize
    @repository   = WebPageDao.new
    @links_table  = LinksTableDao.new
    @indexer      = FactoryIndexer.create(index: "web_pages_1")
    @spider_queue = FactoryQueue.create_spider
    @engine_queue = FactoryQueue.create_engine

    Logs.add(msg: "Engine is Up and Running!!!")
  end

  def run

    @spider_queue.enqueue(msg: "http://www.makeitreal.camp")

    @engine_queue.q.subscribe(block: true) do |delivery_info, properties, msg|
      crawler_message = JSON.parse(msg)

      links = process_web_page(crawler_message: JSON.parse(msg))

      crawl_web(q: @spider_queue, links: links)

      Logs.add(msg: "Query elastic-search with the followin url: #{ crawler_message["url"]}")

      response_doc_id = search_web_pages(query: crawler_message["url"])
      Logs.add(msg: "Response doc id from ES #{response_doc_id}")

      unless response_doc_id == "no records found"
        current_web_page = @repository.find_by(field: :doc_id, value: response_doc_id.first).first.url
        Logs.add(msg: "URL found: #{current_web_page}")
      end

      sleep 2
    end
  end

  private
    def process_web_page(crawler_message:)
      Logs.add(msg: "Receiving url: #{crawler_message["url"]} from crawler")

      html_parsed = parse_html(web_page: crawler_message)
      doc_id      = create_doc_id(url: crawler_message["url"])

      current_web_page = @repository.find_by(field: :doc_id, value: doc_id).first

      unless current_web_page&.indexed
        index_web_page(crawler_message: crawler_message, doc_id: doc_id, html_parsed: html_parsed)
      end

      update_links(html_parsed: html_parsed, doc_id: doc_id)
    end

    def index_web_page(crawler_message:, doc_id:, html_parsed:)
      element = [
        {
          doc_id:      doc_id,
          url:         crawler_message["url"],
          html_parsed: html_parsed
        }
      ]


      save_web_page(web_pages: element)

      current_web_page = @repository.find_by(field: :doc_id, value: doc_id).first

      web_page_idx_template = create_web_page_idx_template(web_page: current_web_page)

      @indexer.index(document: web_page_idx_template) unless web_page_idx_template == "Failed to create document"
    end

    def update_links(html_parsed:, doc_id:)
      links = add_links_to_repository(links: html_parsed[:links])

      update_links_table(doc_id: doc_id, links: links)

      links
    end

    def parse_html(web_page:)
      new_html = HtmlParser.new(url: web_page["url"], html: web_page["html"]).parse
    end

    def create_doc_id(url:)
      vowels        = url.scan(/[aeoui]/).join
      base_id       = str_to_ascii(str: url)
      complement_id = str_to_ascii(str: vowels)

      @doc_id = base_id + complement_id
    end

    def str_to_ascii(str:)
      array = []
      str.each_byte{|ascii| array.push(ascii)}

      array.reduce(&:+)
    end

    def create_web_page_idx_template(web_page:)
      template = web_page.create_document

      return "Failed to create document" unless template

      @repository.update(record: web_page, attributes: {indexed: true})

      template
    end

    def save_web_page(web_pages:)
      web_pages.each do|elem|
        doc_id = elem[:doc_id]

        if @repository.find_by(field: :doc_id, value: doc_id).empty?
          record = {
            doc_id:      doc_id,
            url:         elem[:url],
            html_parsed: elem[:html_parsed]
          }

          @repository.add(record: record)

          if @links_table.find_by(field: :doc_id, value: doc_id).empty?
            save_links(record: {doc_id: doc_id})
          end
        end
      end
    end

    def save_links(record:)
      @links_table.add(record: record)
    end

    def add_links_to_repository(links:)
      web_pages = links.map do|link|
        {
          doc_id:      create_doc_id(url: link),
          url:         link,
          html_parsed: {}
        }
      end

      save_web_page(web_pages: web_pages)

      links
    end

    def update_links_table(doc_id:, links:)
      host = @links_table.find_or_create_by(field: :doc_id, record: {doc_id: doc_id})

      links.each do|link|
        link_doc_id = create_doc_id(url: link)

        visitor = @links_table.find_or_create_by(field: :doc_id, record: {doc_id: link_doc_id})

        host.add_out_link(link: link_doc_id)
        visitor.add_in_link(link: host.doc_id)

        @links_table.update(record: host,    attributes: {out_links: host.out_links})
        @links_table.update(record: visitor, attributes: {in_links: visitor.in_links})
      end
    end

    def crawl_web(q:, links:)
      links.each do|link|
        link_doc_id = create_doc_id(url: link)

        web_page = @repository.find_by(field: :doc_id, value: link_doc_id ).first

        next if web_page.indexed == true

        q.enqueue(msg: link)
      end
    end

    def search_web_pages(query:)
      @indexer.search(phrase: query)
    end
end

engine = Engine.new
engine.run
