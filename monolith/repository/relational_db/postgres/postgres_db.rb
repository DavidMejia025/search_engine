require_relative "../../../services/logs"
require 'pg'

class PostgresDb
  DB_NAME    = "test_aug_29"
  TABLE_NAME = "web_repository"

  attr_accessor :repository, :name

  def initialize(name:)
    connection
    Logs.add(msg: "Connection to Postgress was succesfully establish")
    connect_to_db
    Logs.add(msg: "Connected to db:  #{@db_name}")
    @table_name = name || TABLE_NAME
    create_repository
    Logs.add(msg: "#{@table_name} is up and running")
  end

  def connection
    @con = PG.connect(
      :host => 'localhost',
      :user => 'postgres',
      :password => '123pormi',
    )
  end
#this name: here is an example or application of o/c principle?
  def connect_to_db(name: DB_NAME)
    @db_name = name
#   find_or_create_db(db_name:)
    @con = PG.connect(
      :host => 'localhost',
      :user => 'postgres',
      :password => '123pormi',
      :dbname => @db_name
    )
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
    @con.exec(sql)
  end

  def create_database(name:)
    @con.exec "CREATE DATABASE #{test_aug_29}"
  end

  def create_repository(name: @table_name)
    Logs.add(msg: @table_name)
         #@con.exec "CREATE TABLE Cars(Id INTEGER PRIMARY KEY,
        #Name VARCHAR(20), Price INT)"
#    @con.exec "CREATE TABLE #{@table_name}(
#         docId INTEGER PRIMARY KEY,
#         url VARCHAR(1440),
#         html TEXT
#       )"
  end

  def add_record(record:)
    @con.exec "INSERT INTO cars VALUES  (2, 'mazda', '200000')"

    res = @con.exec "SELECT * FROM cars"
    res.each{|row| Logs.add(msg: row)}
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
