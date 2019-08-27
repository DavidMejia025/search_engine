require_relative "../services/logs"
require_relative "abstract_queue"

require          "rubygems"
require          "bunny"

class RabbitMq < AbstractQueue
  attr_accessor :conn, :q, :x, :ch

  def initialize(name: "america_de_cali")
    start_conection(name: name)
  end

  def start_conection(name:)
     Logs.add(msg: "creating new queue (RABBITMQ) #{name}")

     STDOUT.sync = true

     @conn = Bunny.new(host:  'localhost',
                      port:  '5672',
                      vhost: '/',
                      user:  'guest',
                      pass:  'guest')

     @conn.start

     @ch = @conn.create_channel
     @q  = @ch.queue(name, auto_delete: true)
     @x  = @ch.default_exchange
  end

  def enqueue(msg:)
    @x.publish(msg, routing_key: @q.name)
  end

  def retrieve
    delivery_info, properties, msg = @q.pop
    msg
  end

  def open_connection
    @conn.open
  end

  def close_connection
    @conn.close
  end
end

