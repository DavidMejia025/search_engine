class AbstractRepository
  def establish_connection
    raise "Must override #{__method__}"
  end
# repository should be understud as a db or as a table?
  def create_repository
    raise "Must override #{__method__}"
  end

  def add_record(record:)
    raise "Must override #{__method__}"
  end

  def get_all
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
