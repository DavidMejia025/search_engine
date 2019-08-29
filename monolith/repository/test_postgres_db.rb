require_relative "factory_repository"

class PostgresTest
  attr_accessor :repository
  def initialize
    @repository = FactoryRepository.create_web_pages
    @repository.db_data
  end
end

repository = PostgresTest.new

repository.repository.add_record(record: {doc_id: 1234567890, url: "www.googling.com", html: "DOCTYPE html head body"})