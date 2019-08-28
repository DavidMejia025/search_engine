require_relative "../services/logs"
require_relative "spider"

class Crawler
  def initialize
    unless ObjectSpace.each_object(Spider).count > 0
      return @spider = Spider.new
    end

    Logs.add(msg: "There is already an instance of Spider created,
      use it or deleted it before create a new one")
  end

  def spider
    @spider
  end
end
# Ask for the arquitecture of the Crawler spider to create a singleton,
# There should be an inheritance in place or this implementation is ok?

crawler = Crawler.new

crawler.spider.crawl_web_pages
