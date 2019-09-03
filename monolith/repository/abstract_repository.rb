class AbstractRepository
  def establish_connection
    raise "Must override #{__method__}"
  end
# repository should be understud as a db or as a table?
  def create_repository
    raise "Must override #{__method__}"
  end

  def add(record:)
    raise "Must override #{__method__}"
  end

  def update(attributes:)
    raise "Must override #{__method__}"
  end

  def get_all
    raise "Must override #{__method__}"
  end

  #find_by_primary_key?  what happens in the In memory case
  def find(value)
    raise "Must override #{__method__}"
  end

  def find_by(field:, value:)
    raise "Must override #{__method__}"
  end

  def find_or_create(id:, record:)
    raise "Must override #{__method__}"
  end

  def find_or_create_by(field:, value:)
    raise "Must override #{__method__}"
  end
end
