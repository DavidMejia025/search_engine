class AbstractIndexer
  def index(index:, document:)
    raise "Must override #{__method__}"
  end

  def search(index:, word:)
    raise "Must override #{__method__}"
  end
end
