require_relative "web_page_dao"

# PASS THIS TO RSPEC......
p repository = WebPageDao.new


p repository.add(record: {doc_id: 123, url: "www.google.com", html: "doctype html"})
p repository.add(record: {doc_id: 124, url: "www.google.com", html: "doctype html"})
p repository.add(record: {doc_id: 11, url: "'www.google.com'", html_parsed: "'doctype html'", indexed: false, page_rank:2})
p "11111111111111111111111111!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
p repository.get_all

#p record = repository.find(123)

p record = repository.find_by(field: :doc_id, value: 11).first

p repository.update(record: record, attributes: {doc_id: 5})
#
p record = repository.find_by(field: :doc_id, value: 5).first

p repository.find_or_create_by(field: :doc_id, record: {doc_id: 5})

#p "Repository should contains only one element"
p repository.get_all.count
#
p repository.find_or_create_by(field: :doc_id, record: {doc_id: 27})
#
#p "Repository should contains two  elements"
p repository.get_all.count

