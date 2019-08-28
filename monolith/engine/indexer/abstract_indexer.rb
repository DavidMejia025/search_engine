class AbstractIndexer
# Im still thinking that the index can be should be a parameter for the indexer, what if
  # I want to index diferent documents in diferent indexes or for example like now im testing and I need to create lots of indexes :/. That can be solved by deleting the index and then re creating but I still have my doubts on this one, just to keep thinking on that
  def index(document:)
    raise "Must override #{__method__}"
  end

  def search(query:)
    raise "Must override #{__method__}"
  end
end
