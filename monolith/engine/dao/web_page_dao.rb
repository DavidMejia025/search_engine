require_relative "../../repository/factory_repository"
require_relative "../data_structures/web_page"

class WebPageDao
  def initialize
    @repository = FactoryRepository.create_web_pages
  end

  def add(record:)
    @repository.add(record: record)
  end

  def update(record:, attributes:)
    doc_id = record.first.doc_id

    attributes.merge!(doc_id: doc_id) unless attributes[:doc_id]

   # @repository =  @repository.repository if @repository.class == InMemory
    p record =  @repository.find_by(field: :doc_id, value: doc_id).first
p "222"
p attributes
p record.class
    p web_page_data = record.update(attributes)
  end

  def get_all
    web_pages_data = @repository.get_all

    web_pages_data.map do|web_page_data|
      instance_web_page(web_page_data)
    end
  end

  def find_by(field:, value:)
    p web_pages_data = @repository.find_by(field: field, value: value)

    web_pages_data.map do|web_page_data|
      instance_web_page(web_page_data)
    end
  end

 # def find_or_create(id:, record:)
 #   raise "Must override #{__method__}"
 # end

 # def find_or_create_by(field:, value:)
 #   raise "Must override #{__method__}"
 # end
   def instance_web_page(data)
     WebPage.new(
       doc_id:      data[:doc_id],
       url:         data[:url],
       html_parsed: data[:html],
       page_rank:   data[:page_rank]
     )
   end
end
