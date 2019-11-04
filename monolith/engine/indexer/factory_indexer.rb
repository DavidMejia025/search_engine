require_relative "es_indexer"

class FactoryIndexer
  def self.create(index:)
    Es.new(index: index)
  end
end
