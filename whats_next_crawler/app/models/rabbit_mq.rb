class RabbitMq < ApplicationRecord
  def self.connection
     STDOUT.sync = true

     conn = Bunny.new(host:  'localhost',
                      port:  '5672',
                      vhost: '/',
                      user:  'guest',
                      pass:  'guest')

     conn.start

     ch = conn.create_channel
     q  = ch.queue("crawler_1", :auto_delete => true)
     x  = ch.default_exchange

     {connection: conn, q: q, x: x, ch: ch}
  end

#Define a structure for the bunny object
# ch, q, x
# Probably not necessary when configured properly in rails config files.

  def self.send_message(queue:, msg:)
    queue[:x].publish(msg, :routing_key => queue[:q].name)
  end

  def self.extract_message(queue:)
    delivery_info, properties, msg = queue[:q].pop

    msg
  end

  def self.close_connection(queue:)
    queue[:connection].close
  end
end
