require_relative "rabbitmq_queue"

class AbstractQueue < RabbitMq
   def initialize
     super
   end

  def start_conection
    super
  end

  def enqueue(msg:)
    super
  end

  def retrieve
    super
  end

  def close_conection
    super
  end
end
