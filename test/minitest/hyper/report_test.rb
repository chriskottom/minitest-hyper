require "test_helper"

describe Minitest::Hyper::Report do
  include FilesystemHelpers
  include FilesystemHelpers::Expectations

  let(:reporter) { FakeReporter.new(count: 20) }
  let(:report)   { Minitest::Hyper::Report.new(reporter) }

  it "has a url" do
    expect(report.url).wont_be_nil
  end

  describe "#write" do
    before do
      reset_reports_directory(report.dirname)
    end

    it "writes the report file" do
      expect(report.filename).wont_be_a_file
      report.write
      expect(report.filename).must_be_a_file
    end

    describe "when the report directory doesn't exist" do
      it "creates the report directory" do
        expect(report.dirname).wont_be_a_dir
        report.write
        expect(report.dirname).must_be_a_dir
      end
    end

    describe "when the report file already exists" do
      before do
        touch_report(report.filename)
      end

      let(:out_file) { report.filename }
      let(:time_str) { File.ctime(out_file).strftime("%Y%m%d%H%M%S") }
      let(:new_name) { out_file.sub(/\.html$/, "_#{ time_str }.html") }

      it "moves the existing file to a new location" do
        expect(report.filename).must_be_a_file
        report.write
        expect(report.filename).must_be_a_file
        expect(new_name).must_be_a_file
      end
    end
  end
end
