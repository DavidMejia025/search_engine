require_relative "in_memory/in_memory"
require_relative "relational_db/factory_relational_db"

class FactoryRepository
  
  ENVIRONMENT = "test"
  #ENVIRONMENT = "dev"
  # the beheavior of the in memory is sightly different from the relational db. For example
  # in memory is a single bucket while a db can have multiple tables there should be a way to
  # take this into account. To think deeply later after finishing to implement postgress integration.

  def self.create_web_pages
    return InMemory.new(name: "web_pages") if ENVIRONMENT == "test"

    repository = FactoryRelationalDb.create(name: "web_pages")   
    repository.raw_sql(sql: "DROP TABLE web_pages")
    repository = FactoryRelationalDb.create(name: "web_pages")
# repository.raw_sql(sql: "CREATE EXTENSION hstore") 
    add_columns = "ALTER TABLE web_pages 
                     ADD COLUMN url VARCHAR(1000),
                     ADD COLUMN html_parsed json,
                     ADD COLUMN indexed BOOLEAN,
                     ADD COLUMN page_rank INT"

    repository.raw_sql(sql: add_columns)
    repository
  end

  def self.create_links_table
    return InMemory.new(name: "links_table") if ENVIRONMENT == "test"

    repository = FactoryRelationalDb.create(name: "links_table")
    repository.raw_sql(sql: "DROP TABLE links_table")
    repository = FactoryRelationalDb.create(name: "links_table")

    add_columns = "ALTER TABLE links_table 
                     ADD COLUMN in_links  integer[],
                     ADD COLUMN out_links integer[]"

    repository.raw_sql(sql: add_columns)
    repository
  end
end
