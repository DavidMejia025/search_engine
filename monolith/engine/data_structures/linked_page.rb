class LinkedPage
  attr_accessor :doc_id, :in_links, :out_links

  def initialize(doc_id:)
    @doc_id    = doc_id
    @in_links  = []
    @out_links = []
  end

  def add_in_link(link:)
    @in_links.push(link)
  end

  def add_out_link(link:)
    @out_links.push(link)
  end
end
