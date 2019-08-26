require_relative "abstract_indexer"

require "httparty"

class Es < AbstractIndexer
  def index(index:, document:)
    doc_id = document[:doc_id]
    document = document.to_json

    response =  HTTParty.put(
      "http://localhost:9200/#{index}/_doc/#{doc_id}",
      body:    document,
      headers: {"Content-Type"=> "application/json"}
    )

    response.body
  end

  def search(index:, phrase:)
    query = search_query(phrase: phrase)
p query
    response =  HTTParty.post(
      "http://localhost:9200/#{index}/_search",
       body:    query.to_json,
       headers: {"Content-Type"=> "application/json"}
    )

    response =  JSON.parse(response.body)

    return "no records found" if response["hits"]["total"] == 0

    p response["hits"]["hits"].map {|hit| hit["_source"].keys}
    response["hits"]["hits"].map {|hit| hit["_source"]["doc_id"]}
  end

  def search_query(phrase:)
     #query = {
     #  query: {
     #    match_all: {}
     #  }
     #}
    query = {
      query: {
        multi_match: {
          query:    phrase,
          type:     "best_fields",
          fields:   ["relevant^3", "body"]
        # operator: "and"
        }
      }
    }
  end

  def aggregations
    {
    aggs: {
      type_count: {
        cardinality: {
          html: word
            }
        }
    }
}
  end
end
