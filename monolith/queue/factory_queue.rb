require_relative "rabbitmq_queue"
# require relative "sqs_queue"

#Think twice on the factory GENERAL queue that can create Rabbit sqs and redis queue and
# then have a SE factory queue with spider and engine or something like that think on queue
# as a gem.

class FactoryQueue
  def self.create_spider
    RabbitMq.new(name: "spider")
  end

  def self.create_engine
    RabbitMq.new(name: "engine")
  end
end
