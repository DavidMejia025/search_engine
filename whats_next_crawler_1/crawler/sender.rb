#Spider.gather_web_page
require_relative "../queue/queuee"
p "start"
my_queue = Queuee.new
p "send"
p my_queue.enqueue(msg: "Hi alexa")
p my_queue.enqueue(msg: "Hi David!")
p my_queue.enqueue(msg: "Alexa, Who is charles chaplin")
#
