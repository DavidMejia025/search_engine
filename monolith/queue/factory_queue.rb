require_relative "rabbitmq_queue"
# require relative "sqs_queue"

class FactoryQueue
  def self.create_spider
    RabbitMq.new(name: "spider")
  end

  def self.create_engine
    RabbitMq.new(name: "engine")
  end
end
