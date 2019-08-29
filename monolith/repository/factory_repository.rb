require_relative "in_memory/in_memory"
require_relative "relational_db/factory_relational_db"

class FactoryRepository
  ENVIRONMENT = "development" #"test"
  # the beheavior of the in memory is sightly different from the relational db. For example
  # in memory is a single bucket while a db can have multiple tables there should be a way to
  # take this into account. To think deeply later after finishing to implement postgress integration.

  def self.create_web_pages
    return InMemory.new(name: "web_pages") if ENVIRONMENT == "test"

    FactoryRelationalDb.create(name: "WebPages")
  end

  def self.create_links_table
    return InMemory.new(name: "links_table") if ENVIRONMENT == "test"

    FactoryRelationalDb.create(name: "LinksTable")
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
