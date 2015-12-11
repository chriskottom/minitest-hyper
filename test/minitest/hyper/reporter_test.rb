require "test_helper"

describe Minitest::Hyper::Reporter do
  let(:reporter) { Minitest::Hyper::Reporter.new }

  before do
    reporter.start
  end
  
  describe "#record" do
    it "stores all results, not just interesting results" do
      expect(reporter.all_results).must_be_empty
      reporter.record self
      expect(reporter.all_results.count).must_equal 1
    end
  end
end
