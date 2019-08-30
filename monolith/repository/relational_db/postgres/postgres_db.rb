require_relative "../../../services/logs"
require 'pg'

class PostgresDb
  DB_NAME     = "test_3_aug_29"
  TABLE_NAME  = "web_repository"
  PRIMARY_KEY = "id"

  attr_accessor :repository, :name

  def initialize(name:)
    connection
    Logs.add(msg: "Connection to Postgress was succesfully establish")

    connect_to_db
    Logs.add(msg: "Connected to db:  #{DB_NAME}")

    @table_name = name || TABLE_NAME
    Logs.add(msg: name)

    find_or_create_table(name: @table_name)
    Logs.add(msg: "Table #{@table_name} is up and running")
  end

  def connection
    begin
      @con = PG.connect(
        :host => 'localhost',
        :user => 'postgres',
        :password => '123pormi',
      )
    rescue => e
      Logs.add(msg: "#{e}")
    end
  end

#this name: here is an example or application of o/c principle?
  def connect_to_db(name: DB_NAME)
    begin
      @con = PG.connect(
        :host => 'localhost',
        :user => 'postgres',
        :password => '123pormi',
        :dbname => name
      )
# Adjust the error only for database not found else log error.
    rescue => e
      create_database(name: name)

      connect_to_db
    end
  end

  def db_data
    Logs.add(msg: 'Version of libpg: ' + PG.library_version.to_s)

    begin
        puts @con.server_version
        puts "User: #{@con.user}"
        puts "Database name: #{@con.db}"
        puts "Password: #{@con.pass}"
    rescue PG::Error => e
        puts e.message
    end
  end

  def raw_sql(sql:)
#add some password or protection here.
# see how you send sql to active record"
    query(sql)
  end

  def create_database(name:)
    query("CREATE DATABASE #{name}")
  end

  def delete_database(name:)
    query("DROP DATABASE #{name}")
  end

  def create_repository(name: @table_name)
    query("CREATE TABLE #{name}(doc_id INTEGER PRIMARY KEY, url VARCHAR(255), html TEXT)")
  end

  def delete_repository(name: @table_name)
    query("DROP TABLE #{name}")
  end

  def add_record(id: nil, record:)
    id = id || {PRIMARY_KEY => raw_sql(sql: "SELECT #{PRIMARY_KEY}  FROM #{@table_name} ORDER BY id DESC LIMIT 1").first["#{PRIMARY_KEY}"]}

     query("INSERT INTO #{@table_name}(#{columns}) VALUES(#{values})")

     query("SELECT * FROM #{@table_name} WHERE #{id.keys.first} = #{id.values.first}")
  end

  def get_all
    query("SELECT * FROM cars")
  end

  def find_record(value:)
    query("SELECT * FROM cars WHERE #{PRIMARY_KEY} = 5").first
  end

  def find_record_by(field:, value:)
    begin
      query("SELECT * FROM #{@table_name} WHERE #{field} = #{value}")
    rescue  => e
      {errors: [{not_found: "record #{value} not found"}]}
    end
  end

#Find or create could not be the best name, what about db_xxx_ exist? and then create?
  def find_or_create_table(name:)
    tables = get_table_names

    return Logs.add(msg: "Table #{name} found") if tables.detect{|table| table == name}

    create_repository(name: name)
    Logs.add(msg: "Table #{name} was created")
  end

  def get_table_names
   res = raw_sql(sql: "\SELECT * FROM information_schema.tables")

   res.select{|table| table["table_schema"] == "public"}.map{|row| row["table_name"]}
  end

  def find_or_create_record(field:, value:)
    record = find_record_by(field: field, value: value)

    return record unless record[:errors]

    add_record(field: field, values: values)
  end

  private
    def query(sql)
      @con.exec(sql).map{|row| row}
    end
end
