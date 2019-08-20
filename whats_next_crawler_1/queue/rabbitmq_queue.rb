require "rubygems"
require "bunny"

class RabbitMq
  attr_accessor :conn, :q, :x, :ch

  def initialize
     STDOUT.sync = true

     @conn = Bunny.new(host:  'localhost',
                      port:  '5672',
                      vhost: '/',
                      user:  'guest',
                      pass:  'guest')

     @conn.start

     @ch = conn.create_channel
     @q  = ch.queue("crawler_1", :auto_delete => true)
     @x  = ch.default_exchange
  end

  def enqueue(msg:)
   @x.publish(msg, routing_key: @q.name)
  end

  def retrieve
    delivery_info, properties, msg = @q.pop
p "pop"
p msg
    msg
  end

  def close_connection(queue:)
    @conn.close
  end
end

