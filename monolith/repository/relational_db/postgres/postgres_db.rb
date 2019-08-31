require_relative "../../../services/logs"
require 'pg'
#THink on how to handle errors at wich level...
class PostgresDb
  DB_NAME     = "search_engine_test"
  TABLE_NAME  = "test"
  PRIMARY_KEY = "doc_id"

  attr_accessor :repository, :name

  def initialize(name:)
    connection
    Logs.add(msg: "Connection to Postgress was succesfully establish")

    connect_to_db
    db_data
    Logs.add(msg: "Connected to db:  #{DB_NAME}")

    @table_name = name || TABLE_NAME
    find_or_create_table(name: @table_name)
    Logs.add(msg: "Table #{@table_name} is up and running")
  end

  def raw_sql(sql:)
#add some password or protection here.
# see how you send sql to active record"
    query(sql)
  end

  def create_repository(name: @table_name)
    query("CREATE TABLE #{name}(doc_id INTEGER PRIMARY KEY)")
  end

  def delete_repository(name: @table_name)
    query("DROP TABLE #{name}")
  end

  def get_all
    query("SELECT * FROM #{@table_name}")
  end

  def add(id: nil, record:)
    puts record
    id = id || record[:doc_id] || {PRIMARY_KEY => raw_sql(sql: "SELECT #{PRIMARY_KEY}  FROM #{@table_name} ORDER BY #{PRIMARY_KEY} DESC LIMIT 1").first["#{PRIMARY_KEY}"]}

    columns = "#{id.keys.first}, " + record.keys.join(", ")
    values  = "#{id.values.first}, " + record.values.join(", ")

    query("INSERT INTO #{@table_name}(#{columns}) VALUES(#{values})")

    query("SELECT * FROM #{@table_name} WHERE #{id.keys.first} = #{id.values.first}")
  end

  def update(record:)
#Update record requires more work on pasing the record and the values to be updated
    id = record[PRIMARY_KEY]

    col_val_pairs = record.map do|k,v|
#Review what happens with the type of objects when db returns a record what happen with the var type.
      #      v = 'v'  if v.class == String
      "#{k} = '#{v}'"
    end.join(", ")

    query("UPDATE #{@table_name} SET #{col_val_pairs} WHERE #{PRIMARY_KEY} = #{id} RETURNING #{record.keys.join(', ')}")

    query("SELECT * FROM #{@table_name} WHERE #{PRIMARY_KEY} = #{id}")
  end

  def find(value)
    query("SELECT * FROM #{@table_name} WHERE #{PRIMARY_KEY} = #{value} LIMIT 1").first
  end

  def find_by(field:, value:)
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

  def find_or_create(doc_id:, record:)
    element = find(doc_id.values.first)

    return record unless element.nil?

    add(id: doc_id, record: record)
  end

  private
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
    
    def create_database(name:)
       query("CREATE DATABASE #{name}")
    end

    def delete_database(name:)
      query("DROP DATABASE #{name}")
    end
    
    def get_table_names
     res = raw_sql(sql: "\SELECT * FROM information_schema.tables")

     res.select{|table| table["table_schema"] == "public"}.map{|row| row["table_name"]}
    end

    def query(sql)
      @con.exec(sql).map{|row| row}
    end
end
