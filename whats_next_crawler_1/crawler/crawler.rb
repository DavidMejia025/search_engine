#Spider.gather_web_page
require_relative "../queue/abstract_queue"

my_queue = AbstractQueue.new

p my_queue.enqueue(msg: "Hi alexa")
p my_queue.enqueue(msg: "Hi David!")
p my_queue.enqueue(msg: "Alexa, Who is charles chaplin")

p my_queue.retrieve
p my_queue.retrieve
p my_queue.retrieve
