require "rubygems"
require "bunny"

class RabbitMq
  attr_accessor :conn, :q, :x, :ch

  def initialize(queue = "america_de_cali")
     STDOUT.sync = true

     @conn = Bunny.new(host:  'localhost',
                      port:  '5672',
                      vhost: '/',
                      user:  'guest',
                      pass:  'guest')

     @conn.start

     @ch = @conn.create_channel
     @q  = @ch.queue(queue, auto_delete: true)
     @x  = @ch.default_exchange

    # @q.subscribe(block: true) do |delivery_info, _properties, body|
    #   puts " [x] Received #{body}"
    # end

    # close_connection
  end

  def enqueue(msg:)
   @x.publish(msg, routing_key: @q.name)
  end

  def retrieve
    delivery_info, properties, msg = @q.pop
    msg
  end

  def start_connection
    @conn.start
  end

  def close_connection
    @conn.close
  end
end

