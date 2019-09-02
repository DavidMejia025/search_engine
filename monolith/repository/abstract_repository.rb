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
  
  def update(record:)
    raise "Must override #{__method__}"
  end

  def get_all
    raise "Must override #{__method__}"
  end

  def find(value)
    raise "Must override #{__method__}"
  end

  def find_by(field:, value:)
    raise "Must override #{__method__}"
  end

  def find_or_create(doc_id:, record:)
    raise "Must override #{__method__}"
  end

  def find_or_create_by(field:, value:)
    raise "Must override #{__method__}"
  end
end
