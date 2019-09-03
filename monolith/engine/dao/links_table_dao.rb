require_relative "../../repository/factory_repository"
require_relative "../data_structures/linked_page"

class LinksTableDao
  def initialize
    @repository = FactoryRepository.create_links_table
  end

  def add(record:)
    @repository.add(record: record)
  end

  def update(record:, attributes:)
    hash = from_instance_to_hash(record)
    web_page_data = @repository.update(record: hash, attributes: attributes)

    linked_page = instance_web_page(web_page_data)
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
     attributes = [:in_links, :out_links]

     linked_page = LinkedPage.new(
       doc_id:    query_with_indiferent_access(data: data, key: :doc_id)
     )
     
     attributes.each do|attrb| 
        next unless data[attrb]
          
        linked_page.send("#{attrb}=", data[attrb])
     end

     linked_page
   end

   def from_instance_to_hash(record)
     attributes = ["doc_id", "in_links", "out_links"]
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
end
