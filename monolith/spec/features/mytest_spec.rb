  # spec/features/mytest_spec.rb
require_relative "../../crawler/spider"
require_relative "../../queue/factory_queue"

RSpec.describe "Spider", :type => :feature do
  describe "check smth" do
    it "should be eq" do
      expect(3).to   eq(3)
    end

  #    context "class exist" do
#      subject { Spider.gather_web_pages }
#
#      before(:all) do
#        allow(::FactoryQueue).to receive(:create).and_return(true)
#      end
#
#      it "should call FactoryQueue" do
#        expect(subject).to receive(FactoryQueue.create)
#      end
#    end
  end
end
