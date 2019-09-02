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

  def update(record:)
puts "#{@repository} .............fgdsgdsgdsg sg sdf gsd s dg ......................................."
puts "#{record} ............................................... 5464576547567m ......................."
    record.each do|k, v|
      @repository[k] = v
    end
puts "#{@repository} .............fgdsgdsgdsg sg sdf gsd s dg ......................................."
  end

  def find(value)
    record = @repository.detect do|record|
      record[:doc_id] == value
    end

    record
  end
  #this method should be implememnted with_by but for now I leave it without by.
  def find_or_create(doc_id:, record:)
    element = self.find(value: doc_id)

    return record unless element.nil?

    self.add(record: record)
  end

  def find_by(field:, value:)
#Recap how to get a record from field
    @repository.select {|record| record.field == value}
  end
end
