require_relative "factory_repository"
# This file needs to be cleaned up
class PostgresTest
  attr_accessor :repository
  def initialize
    @repository = FactoryRepository.create_web_pages
    @repository = FactoryRepository.create_links_table
  end
end
repository = PostgresTest.new
#repository.repository.add_record(record: {doc_id: 1234567890, url: "www.googling.com", html: "DOCTYPE html head body"})


#puts repository.repository.get_all
##repository.repository.raw_sql(sql: "SELECT * FROM web_pages")
#
##puts record = repository.repository.find_record(value: 3)
##puts repository.repository.update_record(record: {"doc_id" => 3, html: "doctype_html working and yeahh"})
##puts record = repository.repository.find_record(value: 3)
##repository.repository.find_record_by(field: "id", value: 5)
##repository.repository.add_record(record: "2")
##puts repository.repository.get_all
##repository.repository.delete_repository(name: "test3")
##repository.repository.delete_database(name: "test_aug_29")
##res = repository.repository.raw_sql(sql: "\SELECT * FROM information_schema.tables")
#
##tables = res.select{|table| table["table_schema"] == "public"}.map{|row| row["table_name"]}
##p tables
##
##p repository.repository.find_or_create_table(name: "Omar")
##
#p repository.repository.find_or_create(doc_id: {doc_id: 7}, record: {url: "'www.averalamechita.com'", html: "'doctype_html'"} )
##p repository.repository.add(id: {doc_id: 6}, record: {url: "'www.averalamechita.com'", html: "'doctype_html'"})
#puts repository.repository.get_all
##puts record = repository.repository.find(value: 5)
#puts record = repository.repository.find_by(field: "url", value: "'www.averalamechita.com'")
#
##puts repository.repository.get_all
##puts repository.repository.get_all
##puts repository.repository.get_all

# add columns..
#
# continue:

# PASS THIS TO RSPEC......
p repository = FactoryRelationalDb.create(name: "web_pages")

#p repository.add(record: {doc_id: 126, url: "'www.google.com'", html_parsed: "'doctype html'"})

 repository.get_all

#p record = repository.find(123)

#p record = repository.find_by(field: :doc_id, value: 124).first
#p# record.class
#p repository.update(record: record, attributes: {"doc_id" => 112})

#p repository.find_or_create_by(field: :doc_id, record: {doc_id:  112})
#
#p "Repository should contains only one element"
#p repository.get_all
#
#p repository.find_or_create_by(field: :doc_id, record: {doc_id: 127})
#
#p "Repository should contains two  elements"
#p repository.get_all
#
