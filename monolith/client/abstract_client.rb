class AbstractClient
  def search_web_pages(query:)
    raise "Must override #{__method__}"
  end
end
