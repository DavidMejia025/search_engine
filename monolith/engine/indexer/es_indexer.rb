require_relative "../../services/logs"
require_relative "abstract_indexer"

require "httparty"

class Es < AbstractIndexer
  def initialize(index:)
    @index = index
  end

  def index(document:)
    doc_id   = document[:doc_id]
    document = document.to_json

    response =  HTTParty.put(
      "http://localhost:9200/#{@index}/_doc/#{doc_id}",
      body:    document,
      headers: {"Content-Type"=> "application/json"}
    ).body

    response = JSON.parse(response)

    Logs.add(msg: index_result_message(response: response, doc_id: doc_id))
  end

  def search(phrase:)
    query = search_query(phrase: phrase)

    response =  HTTParty.post(
      "http://localhost:9200/#{@index}/_search",
       body:    query.to_json,
       headers: {"Content-Type"=> "application/json"}
    )

    response =  JSON.parse(response.body)

    return "no records found" if response["hits"]["total"] == 0

    response["hits"]["hits"].map {|hit| hit["_source"]["doc_id"]}
  end

  private
    def index_result_message(response:, doc_id:)
      complement = if response["_shards"]["successful"] != 0
        "was successfully"
      else
        "failed to be"
      end

      "Web page #{doc_id} #{complement} indexed into" +
        "#{response['index']} index"
    end

    def search_query(phrase:)
      query = {
        query: {
          multi_match: {
            query:    phrase,
            type:     "best_fields",
            fields:   ["relevant^3", "body"],
            operator: "and"
          }
        }
      }
    end
end
