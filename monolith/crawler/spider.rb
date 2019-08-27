require_relative "../services/logs/"
require_relative "../queue/factory_queue"

require "httparty"
require "nokogiri"

class Spider
  def crawl_web_pages
    spider_queue = FactoryQueue.create_spider
    engine_queue = FactoryQueue.create_engine

    count = 0

    spider_queue.q.subscribe(block: true) do |delivery_info, properties, url|
      html_content = HTTParty.get(url).body

      engine_queue.enqueue(msg: {url: url, html: html_content}.to_json)

      Logs.add(msg: "Total urls crawled: #{count += 1}")
    end
  end
end

#Implement singleton

crawler = Spider.new

p crawler.crawl_web_pages
