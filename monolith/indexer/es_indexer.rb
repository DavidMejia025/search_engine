require_relative "abstract_indexer"

require "httparty"


class Es < AbstractIndexer
  def index(index:, document:)
   response =  HTTParty.post("http://localhost:9200/#{index}/_doc", body: document, headers:{"Content-Type"=> "application/json"})
   response.body
  end

#  def get_document(index:, document_id:)
#   response = HTTParty.get("http://localhost:9200/#{/_doc", body: document, headers:{"Content-Type"=> "application/json"})
#   response.body
#  end
#XOHQwGwBXhFwQt9P-LzK
  def search(index:, word:)
    response = HTTParty.get("http://localhost:9200/#{index}/_search?q=#{word}")

    response =  JSON.parse(response.body)

    return "no records found" if response["hits"]["total"] == 0

    return response["hits"]["hits"].map {|hit| hit["_source"].keys[0]}
  end
end
