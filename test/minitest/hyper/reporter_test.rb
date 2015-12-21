require "test_helper"

describe Minitest::Hyper::Reporter do
  include FilesystemHelpers
  include FilesystemHelpers::Expectations

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

  describe "#report" do
    before do
      reset_reports_directory
    end

    it "writes the report file" do
      expect(Minitest::Hyper::REPORT_FILE).wont_be_a_file
      capture_subprocess_io do
        reporter.report
      end
      expect(Minitest::Hyper::REPORT_FILE).must_be_a_file
    end

    it "writes the report URL to the console" do
      report_path =  Minitest::Hyper::REPORT_FILE
      regexp = %r{Wrote HTML test report to file://#{ report_path }}
      out, err = capture_subprocess_io do
        reporter.report
      end
      expect(out).must_match regexp
    end
  end
end
