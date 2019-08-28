require_relative "./indexer/factory_indexer"
require_relative "../queue/factory_queue"
require_relative "./parser/html_parser"
require_relative "./data_structures/web_page"
require_relative "./data_structures/linked_page"
require_relative "./indexer/index/index"
require_relative "../repository/factory_repository"

require 'httparty'
require "nokogiri"

class Engine
  def initialize
    @repository   = FactoryRepository.create(name: "web_pages")
    @links_table  = FactoryRepository.create(name: "links_table")

    @index   = "web_pages"
    @indexer = FactoryIndexer.create

    @spider_queue = FactoryQueue.create("spider_queue")
    @engine_queue = FactoryQueue.create("engine_queue")

    puts  "Engine is Up and Running!!!..................................................................................."
  end

  def run
    @spider_queue.enqueue(msg: "http://www.eltiempo.com")

    @engine_queue.q.subscribe(block: true) do |delivery_info, properties, body|
      web_page =  JSON.parse(body)

      puts "Receiving url:  #{web_page["url"]} from crawler.............................................................."

      doc_id = create_doc_id(url: web_page["url"])

      current_web_page = @repository.find_record(value: doc_id)

      unless current_web_page&.indexed
        html_parsed = parse_html(web_page: web_page)

        attributes = {web_page: web_page, doc_id: doc_id, html_parsed: html_parsed}

        store_web_page(attributes: attributes)

        current_web_page = @repository.find_record(value: doc_id)
  # What should be the good practice: encapsulate index in a method or leave as it is here?
        Index.index_web_page(
          web_page:   current_web_page,
          doc_id:     doc_id,
          attributes: {indexer: @indexer, index: @index}
        )

        links = add_links_to_repository(links: html_parsed[:links])

        update_links_table(doc_id: doc_id, links: links)

        crawl_web(q: @spider_queue, links: links)

        puts "Query elastic-search with the followin url: #{ web_page["url"]}................................................"
puts "111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"
puts        response_doc_id = search_web_pages(query: web_page["url"])

        unless response_doc_id == "no records found"
          current_web_page = @repository.find_record(value: response_doc_id.first).url

          puts "URL found: #{current_web_page} .............................................................................."
        end
        sleep 2
      end
    end
  end

  def create_doc_id(url:)
    base_id = str_to_ascii(str: url)

    vowels = url.scan(/[aeoui]/).join

    complement_id = str_to_ascii(str: vowels)

    @doc_id = base_id + complement_id
  end

  def str_to_ascii(str:)
    array = []

    str.each_byte{|ascii| array.push(ascii)}

    array.reduce(&:+)
  end

  def parse_html(web_page:)
    new_html = HtmlParser.new(url: web_page["url"], html: web_page["html"]).parse
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
p   @indexer.search(index: @index, phrase: query)
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
end

engine = Engine.new

engine.run
