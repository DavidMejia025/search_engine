require_relative "../queue/factory_queue"

require "httparty"
require "nokogiri"

class Spider
  def self.gather_web_pages(url = "http://www.makeitreal.camp")
    queue = FactoryQueue.create

    count = 0

    queue.enqueue(msg: url)

    queue.q.subscribe(block: true) do |delivery_info, properties, body|
p     body
      html_content = grab_web_page(url: body)

      links = get_links(url: url, html_content: html_content)

        links.each {|link| queue.enqueue(msg: link)}
p       count += 1
    end
  end

  def self.grab_web_page(url:)
    html_content    = HTTParty.get(url)
    document_parsed = parse(resource: html_content)
  end

  def self.parse(resource:)
    Nokogiri::HTML(resource)
  end

  def self.get_links(url:, html_content:)
    links = html_content.search("a").map{|node| node.attributes['href']&.value}

    links.map do|link|
      next nil  if link.nil? ||  link.length == 1

      next link if link =~ /http/

      url + link
    end.reject{|link| link == nil}
  end
end

