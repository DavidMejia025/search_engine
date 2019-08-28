class RelationalDb
  attr_accessor :repository, :name
  def create_repository

  end

  def add
    raise "Must override #{__method__}"
  end

  def find_record
    raise "Must override #{__method__}"
  end

  def find_record_by(field:, value:)
    raise "Must override #{__method__}"
  end

  def find_or_create(value:)
    raise "Must override #{__method__}"
  end
end
