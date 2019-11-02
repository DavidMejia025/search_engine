require_relative "es_indexer"
# Think more on the beheavior of the Factory it is just intend to have one create method
# and select only one implementation, even though it makes sense and is very useful, at the same 
# time it looks limited and waste of possibility to me.

class FactoryIndexer
  def self.create(index:)
    Es.new(index: index)
  end
end
