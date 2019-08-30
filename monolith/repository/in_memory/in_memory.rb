require_relative "../../services/logs"
require_relative "../abstract_repository"

class InMemory < AbstractRepository
  attr_accessor :repository, :name

  def initialize(name:)
    create_repository(name: name)
  end

  def create_repository(name:)
    @repository = []
    @name       = name
  end

  def get_all
    @repository
  end

  def add(record:)
    @repository.push(record)

    @repository.last
  end

  def find_record(value:)
    @repository.detect {|record| record.doc_id == value}
  end

  def find_or_create(value:)
    record = self.find_record(value: value)

    return record unless record.nil?

    self.add(record: LinkedPage.new(doc_id: value))
  end

  def find_record_by(field:, value:)
#Recap how to get a record from field
    @repository.select {|record| record.field == value}
  end
end
