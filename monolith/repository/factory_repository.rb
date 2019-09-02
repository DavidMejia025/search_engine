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

    add_columns = "ALTER TABLE web_pages 
                     ADD COLUMN url VARCHAR(1000),
                     ADD COLUMN html_parsed TEXT,
                     ADD COLUMN indexed BOOLEAN,
                     ADD COLUMN page_rank INT"

    #repository.raw_sql(sql: add_columns)
    repository
  end

  def self.create_links_table
    return InMemory.new(name: "links_table") if ENVIRONMENT == "test"

    repository = FactoryRelationalDb.create(name: "links_table")

    add_columns = "ALTER TABLE links_table 
                     ADD COLUMN in_links VARCHAR(2000),
                     ADD COLUMN out_links VARCHAR(2000)"

    #repository.raw_sql(sql: add_columns)
    repository
  end

# Maybe repository is not appropiate for db but for a bucket think about the configuration or setup
# in the relational db case.
#
#  def self.create_bucket
#  end
#
#  def self.create_db
#  end
end
