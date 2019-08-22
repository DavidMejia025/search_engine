require 'httparty'
html_doc = ""

html_file = File.open("html_doc.txt")

p html_file = html_file.map {|line|  line}
p html_file.count
p html_doc = html_file.first
endpoint="https://localhost:9200/pages/_doc/1"

data= {
      make_it: html_doc
      }
#response = HTTParty.put(endpoint,
#                         :body => data.to_json,
#                         :headers => { "Content-Type" => 'application/json'})


response = HTTParty.put("http://localhost:9200/pages/_doc/1", body: data.to_json, headers:{"Content-Type"=> "application/json"})
p "INDEXEDDDDDDD"
puts response.body
  response = HTTParty.get("http://localhost:9200/pages/_search?q=web:Patricia")
p "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
p "whats on the es "
puts response.body
puts "FINISH of the test :) !!! "
