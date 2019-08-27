require_relative "abstract_client"
require_relative "../engine"

# background jobs
class Client
  def initialize
  end

  def search_web_pages(query:)
p  Engine.search(phrase: query)
  end
end

se_client = Client.new

se_client.search_web_pages(query: "hola")
