require_relative "es_indexer"

class FactoryIndexer
  def self.create
    Es.new
  end
end
