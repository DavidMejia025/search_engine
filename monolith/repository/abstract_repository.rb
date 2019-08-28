class AbstractRepository
  def create_repository
    raise "Must override #{__method__}"
  end

  def add(record:)
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

  def find_or_create_by(field:, value:)
    raise "Must override #{__method__}"
  end
end