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
    let(:report_dir)  { Minitest::Hyper.report_dirname }
    let(:report_file) { Minitest::Hyper.report_filename }

    before do
      reset_reports_directory(report_dir)
    end

    it "writes the report file" do
      expect(report_file).wont_be_a_file
      capture_subprocess_io do
        reporter.report
      end
      expect(report_file).must_be_a_file
    end

    it "writes the report URL to the console" do
      regexp = %r{Wrote HTML test report to file://#{ report_file }}
      out, err = capture_subprocess_io do
        reporter.report
      end
      expect(out).must_match regexp
    end
  end
end
