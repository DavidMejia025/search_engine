require_relative "../services/logs/"
require_relative "./indexer/factory_indexer"
require_relative "../queue/factory_queue"
require_relative "./parser/html_parser"
require_relative "./data_structures/web_page"
require_relative "./data_structures/linked_page"
require_relative "../repository/factory_repository"

require 'httparty'
require "nokogiri"

class Engine
  def initialize
    @repository   = FactoryRepository.create_web_pages
    @links_table  = FactoryRepository.create_links_table
#Still have doubts about sending index name from here...
    @indexer      = FactoryIndexer.create(index: "web_pages_1")
    @spider_queue = FactoryQueue.create_spider
    @engine_queue = FactoryQueue.create_engine

    Logs.add(msg: "Engine is Up and Running!!!)")
  end

  def run
    @spider_queue.enqueue(msg: "http://www.marca.com")

    @engine_queue.q.subscribe(block: true) do |delivery_info, properties, msg|
      crawler_message = JSON.parse(msg)
# This links = process smells for me.....
      links = process_web_page(crawler_message: JSON.parse(msg))

      crawl_web(q: @spider_queue, links: links)

      Logs.add(msg: "Query elastic-search with the followin url: #{ crawler_message["url"]}")

      response_doc_id = search_web_pages(query: crawler_message["url"])

      Logs.add(msg: "Response doc id from ES #{response_doc_id}")

      unless response_doc_id == "no records found"
        current_web_page = @repository.find_record(value: response_doc_id.first).url

        Logs.add(msg: "URL found: #{current_web_page}")
      end

      sleep 2
    end
  end

  private
    def process_web_page(crawler_message:)
      Logs.add(msg: "Receiving url:  #{crawler_message["url"]} from crawler")

      html_parsed = parse_html(web_page: crawler_message)
      doc_id      = create_doc_id(url: crawler_message["url"])

      current_web_page = @repository.find_record(value: doc_id)
#index is a reserved word? it looks like so
      unless current_web_page&.indexed
        index_web_page(crawler_message: crawler_message, doc_id: doc_id, html_parsed: html_parsed)
      end
#try to pass current web page instead of doc_id thats a better idea or not?
      update_links(html_parsed: html_parsed, doc_id: doc_id)
    end

    def index_web_page(crawler_message:, doc_id:, html_parsed:)
      attributes  = {web_page: crawler_message, doc_id: doc_id, html_parsed: html_parsed}
      store_web_page(attributes: attributes)
#see if this current web page is uneccesary
      current_web_page      = @repository.find_record(value: doc_id)
      web_page_idx_template = create_web_page_idx_template(web_page: current_web_page)

      @indexer.index(document: web_page_idx_template) unless web_page_idx_template == "Failed to create document"
    end
#This method could have a better name if you want try guessing something else
    def update_links(html_parsed:, doc_id:)
      links = add_links_to_repository(links: html_parsed[:links])

      update_links_table(doc_id: doc_id, links: links)
#Not sure if this is the best way to pass the links to the enqueue or its better to have a memory alocation
#for current links in links table or something like that, but in that case the traidoff of requestiong or hitting
# the database multilple times could cound and affect what do you think on this?
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
#optimize? with reduce
      str.each_byte{|ascii| array.push(ascii)}

      array.reduce(&:+)
    end

    def store_web_page(attributes:)
      doc_id = attributes[:doc_id]

      save_web_page(
        element: [
          {
            doc_id:      doc_id,
            url:         attributes[:web_page]["url"],
            html_parsed: attributes[:html_parsed]}
        ]
      )

      unless @links_table.find_record(value: doc_id)
        linked_page = @links_table.add(record: LinkedPage.new(doc_id: doc_id))
      end
    end

    def create_web_page_idx_template(web_page:)
      template = web_page.create_document

      return "Failed to create document" unless template

      web_page.indexed = true

      template
    end

    def save_web_page(element:)
      element.each do|elem|
        unless @repository.find_record(value: elem[:doc_id])
          web_page_element = WebPage.new(
            doc_id:      elem[:doc_id],
            url:         elem[:url],
            html_parsed: elem[:html_parsed]
          )

          @repository.add(record: web_page_element)
        end
      end
    end

    def add_links_to_repository(links:)
      links = links.map do|link|
        {
          doc_id:      create_doc_id(url: link),
          url:         link,
          html_parsed: ""
        }
      end

      save_web_page(element: links)

      links
    end

    def update_links_table(links_table: @links_table, doc_id:, links:)
      host = @links_table.find_or_create(value: doc_id)

      links.each do|link|
        visitor = @links_table.find_or_create(value: link[:doc_id])

        host.add_out_link(link: link[:doc_id])
        visitor.add_in_link(link: doc_id)
      end
    end

    def crawl_web(q:, repository: @repository, links:)
      links.each do|link|
        web_page = @repository.find_record(value: link[:doc_id])

        next if web_page.indexed == true

        q.enqueue(msg: link[:url])
      end
    end

    def search_web_pages(query:)
      @indexer.search(phrase: query)
    end
end

engine = Engine.new

engine.run
