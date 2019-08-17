require_relative "rabit"
class QueueFactory < RabbitMq
  def create
    RabbitMq.new
  end
end
