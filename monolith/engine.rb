require_relative "./indexer/factory_indexer"
require_relative "spider"
require 'httparty'
html_doc = ""

html_file = File.open("html_doc.txt")

 html_file = html_file.map {|line|  line}
 html_file.count
 html_doc = html_file.first
#p "data new"
#data1= { make_it1: "html_doc" }
#data2= {
#  make_itr5: "good fiz"
#      }
#
#data3= {
#  make_it3: "fiz"
#      }
#
data4= {
      make_it4: " fiz buz"
     }
#
indexer = FactoryIndexer.create
#
#p indexer.index(index: "hola", document: data1.to_json)
#p indexer.index(index: "hola", document: data2.to_json)
#

p "22222222"

url = ["http://www.makeitreal.camp", "http://www.marca.com","http://www.eltiempo.com"]
index0 = "carlos"

data = url.map{|url0| {"#{url0}" => HTTParty.get(url0).body}.to_json}

data.each {|d| indexer.index(index: index0, document: d)}

p indexer.search(index: index0, word: "make it real")

p "11111111111111111111111111111!!!!!"




#p indexer.index(index: index, document: data4.to_json)
#
#p indexer.search(index: "hola", word: "fiz")
