require_relative "rabbitmq_queue"

class FactoryQueue < RabbitMq
  def self.create(queue)
    RabbitMq.new(queue)
  end
end
