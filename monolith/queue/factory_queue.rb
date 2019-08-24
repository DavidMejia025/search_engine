require_relative "rabbitmq_queue"

class FactoryQueue < RabbitMq
  def self.create
    RabbitMq.new
  end
end
