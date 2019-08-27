class Index
  def self.index_web_page(web_page:, doc_id:, attributes:)
     document = web_page.create_document

     return "Faild to create document" unless document

     p attributes[:indexer].index(
       index: attributes[:index],
       document: document
     )

     web_page.indexed = true

  end
end
