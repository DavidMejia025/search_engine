require_relative "in_memory"
require_relative "relational_db"

class FactoryRepository
# Select repository depending on the environment
  def self.create(name:)
    InMemory.new(name: name)
  end
end
