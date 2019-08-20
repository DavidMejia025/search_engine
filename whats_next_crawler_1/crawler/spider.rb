require_relative "/queue/abstract_queue"

class Spider
  def self.gather_web_pages(url = "http://www.makeitreal.camp")
    count = 0

    while count  < 3
      html_content = grab_web_page(url: url)

      links = get_links(url: url, html_content: html_content)

      links.each {|link| Spider.enqueue(msg: link)}

      url = Spider.queue_pop

      count += 1
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
    links = html_content.search("a").map{|node| node.attributes['href'].try(:value)}

    links.map do|link|
      next nil  if link.nil? ||  link.length == 1

      next link if link =~ /http/

      url + link
    end.reject{|link| link == nil }
  end

  def self.enqueue(msg:)
    queue = RabbitMq.connection

    RabbitMq.send_message(queue: queue, msg: msg)
  end

  def self.queue_pop
    queue = RabbitMq.connection

    RabbitMq.extract_message(queue: queue)
  end
end

