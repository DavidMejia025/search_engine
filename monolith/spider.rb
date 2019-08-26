require_relative "./queue/factory_queue"

require "httparty"
require "nokogiri"

class Spider
  def self.gather_web_pages
    spider_queue = FactoryQueue.create("spider_queue")

    engine_queue = FactoryQueue.create("engine_queue")

p    count = 0

    spider_queue.q.subscribe(block: true) do |delivery_info, properties, url|
p url
    html_content = HTTParty.get(url).body
p "after url "
engine_queue.enqueue(msg: {url: url, html: html_content}.to_json)
p       count += 1
    end
  end
end

p Spider.gather_web_pages
