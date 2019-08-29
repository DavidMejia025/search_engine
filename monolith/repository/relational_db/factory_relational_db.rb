require_relative "./postgres/postgres_db"
#require_relative "mysql"

class FactoryRelationalDb
  def self.create(name:)
    PostgresDb.new(name: name)
  end
end
