class HtmlParser
  def initialize(url:, html:)
    @html = Nokogiri::HTML(html)
    @url  = url
  end

  def parse
    {relevant: relevant, body: body, links: get_links}
  end

  def relevant
    meta   = @html.search("head").to_s

    titles = @html.search("h1").map{|node| node.text}.join(" ") + " " +
      @html.search("h2").map{|node| node.text}.join(" ") + " " +
      @html.search("h3").map{|node| node.text}.join(" ")

    url = @url.split(/[.,\/]/).join(" ")

    meta + " " +  titles + " " + url
  end

  def body
    @html.search("body").to_s
  end

  def get_links
    links = @html.search("a").map{|node| node.attributes['href']&.value}

    links.map do|link|
      next nil  if link.nil? ||  link.length == 1

      next link if link =~ /http/

      nil
    end.reject{|link| link == nil}
  end
end
