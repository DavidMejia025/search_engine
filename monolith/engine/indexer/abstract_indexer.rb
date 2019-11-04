class AbstractIndexer
  def index(document:)
    raise "Must override #{__method__}"
  end

  def search(query:)
    raise "Must override #{__method__}"
  end
end
