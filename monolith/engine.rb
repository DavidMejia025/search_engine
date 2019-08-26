require_relative "./indexer/factory_indexer"
require_relative "./queue/factory_queue"
require_relative "./parser/html_parser"
require_relative "./web_page/web_page"
require_relative "./linked_page/linked_page"

require 'httparty'
require "nokogiri"

#data4=
#  {
#    doc_id: "3",
#    html: "2 what if tomorrow is today amd america de cali is the best team in the history",
#    checksum: "2"
# }
#
def engine
  repository   = []
  links_table  = []

  indexer = FactoryIndexer.create

  spider_queue = FactoryQueue.create("spider_queue")

  engine_queue = FactoryQueue.create("engine_queue")

  spider_queue.enqueue(msg: "http://www.eltiempo.com")

  engine_queue.q.subscribe(block: true) do |delivery_info, properties, body|
    web_page =  JSON.parse(body)
p "from spider url"
p web_page["url"]
p " url"

p    doc_id = create_doc_id(url: web_page["url"])

    current_web_page = get_from_repository(repository: repository, doc_id: doc_id)

    unless current_web_page&.indexed
      html_parsed = parse_html(web_page: web_page)

p html_parsed
      attributes = {web_page: web_page, doc_id: doc_id, htoml_parsed: html_parsed}

      save_web_page(repository: repository, links_table: links_table, attributes: attributes)
p doc_id
      index_web_page(repository: repository, doc_id: doc_id)

      links = add_links_to_repository(repository: repository, links: html_parsed[:links])

      update_links_table(links_table: links_table, doc_id: doc_id, links: links)

      crawl_web(q: spider_queue, repository: repository, links: links)
    end
  end
end
#p indexer.search(index: index, phrase: "nicolucas")
def create_doc_id(url:)
  base_id = str_to_ascii(str: url)

  vowels = url.scan(/[aeoui]/).join

  complement_id = str_to_ascii(str: vowels)

  base_id + complement_id
end

def str_to_ascii(str:)
  array = []

  str.each_byte{|ascii| array.push(ascii)}

  array.reduce(&:+)
end

def parse_html(web_page:)
  new_html = HtmlParser.new(url: web_page["url"], html: web_page["html"]).parse
end

def update_links_table(links_table:, doc_id:, links:)
  host = find_or_create_linked_page(links_table: links_table, doc_id: doc_id)

  links.each do|link|
    visitor = find_or_create_linked_page(links_table: links_table, doc_id: link[:doc_id])

    host.add_out_link(link: link[:doc_id])

    visitor.add_in_link(link: doc_id)
  end
end

def find_or_create_linked_page(links_table:, doc_id:)
  linked_page = links_table.select {|linked_element| linked_element.doc_id == doc_id}

  return linked_page.first unless linked_page.empty?

  create_linked_page(links_table: links_table, doc_id: doc_id)
end

def linked_page_exists?(links_table:, doc_id:)
  links_table.detect {|record| record.doc_id == doc_id} ? true : false
end

def create_linked_page(links_table:, doc_id:)
  unless links_table.detect {|record| record.doc_id == doc_id}
    links_table.push(LinkedPage.new(doc_id: doc_id))
  end

  links_table.last
end

def add_to_repository(repository:, element:)
  element.each do|elem|
    unless repository.detect {|record| record.doc_id == elem[:doc_id]}
p "2222222222222222222222222222222222"
p      elem[:html_parsed]
      repository.push(WebPage.new(doc_id: elem[:doc_id], url: elem[:url], html_parsed: elem[:html_parsed]))
    end
  end
end

def get_from_repository(repository:, doc_id:)
  repository.detect {|record| record.doc_id == doc_id}
end

def crawl_web(q:, repository:, links:)
  links.each do|link|
    web_page = get_from_repository(repository: repository, doc_id: link[:doc_id])

    next if web_page.indexed == true

    q.enqueue(msg: link[:url])
  end
end

def save_web_page(repository:, links_table:, attributes:)
p attributes[:html_parsed]
  add_to_repository(
    repository: repository,
    element: [
      {
        doc_id:      attributes[:doc_id],
        url:         attributes[:web_page]["url"],
        html_parsed: attributes[:html_parsed]}
    ]
  )

  create_linked_page(links_table: links_table, doc_id: attributes[:doc_id])
end

def index_web_page(repository:, doc_id:)
  current_web_page = get_from_repository(repository: repository, doc_id: doc_id)
p doc_id
  document = current_web_page.create_document
p "111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"
  p document
#  indexer.index(index: index, document: document)

  current_web_page.indexed = true
end

def add_links_to_repository(repository:, links:)
  links = links.map{|link| {doc_id: create_doc_id(url: link), url: link, html_parsed: ""}}

  add_to_repository(repository: repository, element: links)

  links
end


engine
