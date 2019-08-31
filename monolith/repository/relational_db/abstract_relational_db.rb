#Needs a second review before present it 
class AbstractRelationalDb < AbstractRepository
  def create_repository(name:)
    raise "Must override #{__method__}"
  end

  def delete_repository(name:
    raise "Must override #{__method__}"
  end

  def create_database(name:)
    raise "Must override #{__method__}"
  end

  def delete_database(name:)
    raise "Must override #{__method__}"
  end

  def update
    raise "Must override #{__method__}"
  end

  def connect_to_db(name:)
    raise "Must override #{__method__}"
  end

  def find_or_create_table(name:)
    raise "Must override #{__method__}"
  end

  def db_data
    raise "Must override #{__method__}"
  end

  def def get_table_names
    raise "Must override #{__method__}"
  end

  def query(sql)
    raise "Must override #{__method__}"
  end

  def establish_connection
    raise "Must override #{__method__}"
  end
end