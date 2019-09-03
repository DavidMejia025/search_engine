require_relative "../../repository/factory_repository"
require_relative "../data_structures/web_page"

require 'json'

class WebPageDao
  attr_accessor :repository

  def initialize
    @repository = FactoryRepository.create_web_pages
  end

  def add(record:)
    @repository.add(record: record)
  end

  def update(record:, attributes:)
    hash = from_instance_to_hash(record)
    web_page_data = @repository.update(record: hash, attributes: attributes)

    instance_web_page(web_page_data)
  end

  def get_all
    web_pages_data = @repository.get_all

    web_pages_data.map do|web_page_data|
      instance_web_page(web_page_data)
    end
  end

  def find_by(field:, value:)
    web_pages_data = @repository.find_by(field: field, value: value)

    web_pages_data.map do|web_page_data|
      instance_web_page(web_page_data)
    end
  end

 # def find_or_create(id:, record:)
 #   raise "Must override #{__method__}"
 # end

  def find_or_create_by(field:, record:)
    web_page_data = @repository.find_or_create_by(field: field, record: record)

    instance_web_page(web_page_data)
  end

   def instance_web_page(data)
      WebPage.new(
        doc_id:      query_with_indiferent_access(data: data, key: :doc_id),
        url:         query_with_indiferent_access(data: data, key: :url),
        html_parsed: parse_html_parsed(query_with_indiferent_access(data: data, key: :html_parsed)),
        page_rank:   query_with_indiferent_access(data: data, key: :page_rank)
     )
   end

   def from_instance_to_hash(record)
     attributes = ["doc_id", "url", "html_parsed", "indexed", "page_rank"]
     i = 0

     result = attributes.reduce({}) do|accu, attribute|
       current_attribute = attributes[i]
       accu.merge!({current_attribute => record.send("#{current_attribute}")})

       i += 1
       accu
     end
   end

   def query_with_indiferent_access(data:, key:)
     data[key] || data[key.to_s]
   end

   def parse_html_parsed(html_parsed)
      html_parsed = JSON.parse(html_parsed) unless @repository.class == InMemory
      html_parsed
   end
end
