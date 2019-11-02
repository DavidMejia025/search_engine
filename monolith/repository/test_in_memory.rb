require_relative "in_memory/in_memory"

# PASS THIS TO RSPEC......
p repository = InMemory.new(name: "web_pages")

p repository.add(record: {doc_id: 123, url: "www.google.com", html: "doctype html"})


p repository.get_all

#p record = repository.find(123)

p record = repository.find_by(field: :doc_id, value: 123).first
p record.class
p repository.update(record: record, attributes: {doc_id:  112})

p repository.get_all

#p repository.find_or_create_by(field: :doc_id, record: {doc_id:  112})

#p repository.find_or_create_by(field: :doc_id, record: {doc_id: 124})

#p "Repository should contains only one element"
#p repository.get_all

#p repository.find_or_create_by(field: :doc_id, record: {doc_id: 127})

#p "Repository should contains two  elements"
#p repository.get_all

