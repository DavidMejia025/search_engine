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
    self.repository
  end

  def add(record:)
    self.repository.push(record)

    self.repository.last
  end

  def update(record:, attributes:)
    p attributes
    p"333"
    p in_memory_record = self.repository.select {|record| record == record}.first

    attributes.each do|k, v|
      in_memory_record[k] = v
    end

    in_memory_record
  end
# this should be the way given the way it is  implemented as array but ....
  def find(value)
    self.repository[value]
  end

#Assuming that all information is in the form of hashes. Dont like it but leave it like this for now.
 # def find(value)
 #   result = self.repository.detect do|record|
 #     record[:doc_id] == value
 #   end

 #   result
 # end

#Assuming that all information is in the form of hashes. Dont like it but leave it like this for now.
  def find_by(field:, value:)
    self.repository.select {|record| record[field] == value}
  end

#  def find_or_create(doc_id:, record:)
#    element = self.find(doc_id)
#
#    return element unless element.nil?
#
#    self.add(record: record)
#  end
  def find_or_create_by(field:, record:)
    element = self.find_by(field: field, value: record[field])

    return element.first unless element.empty?

    self.add(record: record)
  end
end
