require_relative "../../services/logs"

class WebPage
  attr_accessor :indexed, :url, :doc_id, :html_parsed, :page_rank

  def initialize(doc_id: 1, url:,  html_parsed: "", page_rank: 1)
    @html_parsed = html_parsed
    @doc_id      = doc_id
    @url         = url
    @page_rank   = page_rank
    @indexed     = false
  end

  def create_document
    document = nil

    unless (@html_parsed.nil? || @html_parsed.empty?)
      document =  {
        doc_id:   @doc_id,
        relevant: @html_parsed[:relevant],
        body:     @html_parsed[:body]
      }
    end

    document
  end
end
