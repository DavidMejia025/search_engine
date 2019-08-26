require_relative "../engine"

class Index < Engine
  def self.index_web_page(repository:, doc_id:, attributes:)
     current_web_page = get_from_repository(repository: repository, doc_id: doc_id)

     document = current_web_page.create_document

     p attributes[:indexer].index(index: attributes[:index], document: document)

     current_web_page.indexed = true
  end
end
