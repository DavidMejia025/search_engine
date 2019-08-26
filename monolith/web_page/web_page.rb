class WebPage
  attr_accessor :indexed, :url, :doc_id, :html_parsed, :page_rank

  def initialize(doc_id: 1, url:,  html_parsed: "", page_rank: 1)
    @doc_id      = doc_id
    @url         = url
    @html_parsed = html_parsed
    @page_rank   = page_rank
    @indexed     = false
  end

  def create_document
    p self

    unless @html_parsedi.nil?
      {
        doc_id:   @doc_id,
        relevant: @html_parsed[:relevant],
        body:     @html_parsed[:body]
      }
    end
  end
end
