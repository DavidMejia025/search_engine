require_relative "links_table_dao"

# PASS THIS TO RSPEC......
p repository = LinksTableDao.new


#p repository.add(record: {doc_id: 123, in_links: "www.google.com", out_links: "doctype html"})
#p repository.add(record: {doc_id: 124, in_links: "www.google.com", out_links: "doctype html"})
p repository.add(record: {doc_id: 55})

p record = repository.find_by(field: :doc_id, value: 55).first

p repository.get_all

#p record = repository.find(123)

p repository.update(record: record, attributes: {in_links: true})
#
p record = repository.find_by(field: :doc_id, value: 55).first

p repository.find_or_create_by(field: :doc_id, record: {doc_id: 55})

p "Count Repository elements"
p repository.get_all.count

p repository.find_or_create_by(field: :doc_id, record: {doc_id: 22})

p "Repository should contains one more element"
p repository.get_all.count

