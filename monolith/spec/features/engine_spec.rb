# spec/features/mytest_spec.rb
require_relative "../../engine/indexer/factory_indexer"
require_relative "../../engine/parser/html_parser"
require_relative "../../engine/indexer/index/index"
require_relative "../../engine/data_structures/web_page"
require_relative "../../engine/data_structures/linked_page"
#require_relative "../../crawler/spider"
require_relative "../../queue/factory_queue"

RSpec.describe "Engine", :type => :feature do
  describe "check smth" do
    it "should be eq" do
      expect(3).to   eq(3)
    end

    #context "create doc id" do
    #  subject { Engine.new.create_doc_id(url: "www.eltiempo.com") }

    #  before(:all) do
    #    allow(::FactoryQueue).to receive(:create).and_return(true)
    #  end

    #  it "returns the corresponding doc_id" do
    #    expect(subject).to eq(2704)
    #  end
    #end
  end
end
