require_relative "in_memory"
require_relative "relational_db"

class FactoryRepository
# Select repository depending on the environment
  def self.create_web_pages
    InMemory.new(name: "web_pages")
  end

  def self.create_links_table
    InMemory.new(name: "links_table")
  end
end
