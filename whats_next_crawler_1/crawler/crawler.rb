#Spider.gather_web_page
require_relative "../queue/abstract_queue"

my_queue = AbstractQueue.new

p my_queue.q.name


p my_queue.enqueue(msg:"Hi David!")

p my_queue.retrieve
