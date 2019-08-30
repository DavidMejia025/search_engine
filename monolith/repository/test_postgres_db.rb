require_relative "factory_repository"

class PostgresTest
  attr_accessor :repository
  def initialize
    @repository = FactoryRepository.create_web_pages
    @repository.db_data
  end
end

repository = PostgresTest.new

#repository.repository.add_record(record: {doc_id: 1234567890, url: "www.googling.com", html: "DOCTYPE html head body"})


#puts repository.repository.get_all
#repository.repository.raw_sql(sql: "SELECT * FROM cars")
#repository.repository.find_record(value: 5)
#repository.repository.find_record_by(field: "id", value: 5)
#repository.repository.add_record(record: "2")
#puts repository.repository.get_all
#repository.repository.delete_repository(name: "test3")
#repository.repository.delete_database(name: "test_aug_29")
#res = repository.repository.raw_sql(sql: "\SELECT * FROM information_schema.tables")

#tables = res.select{|table| table["table_schema"] == "public"}.map{|row| row["table_name"]}
#p tables
#
#p repository.repository.find_or_create_table(name: "Omar")
#
#p repository.repository.find_or_create_record(field: "id", value: 2)
p repository.repository.add_record(id: {doc_id: 4}, record: {url: "'www.vamosacaliaveralamechita.com'", html: "'doctype_html2'"})
