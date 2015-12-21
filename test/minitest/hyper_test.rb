require 'test_helper'
require "fileutils"
require "ostruct"

describe Minitest::Hyper do
  it "has a version" do
    expect(Minitest::Hyper::VERSION).wont_be_nil
  end

  it "can be enabled" do
    Minitest::Hyper.class_variable_set(:@@enabled, false)
    Minitest::Hyper.enable!
    assert Minitest::Hyper.enabled?
  end

  describe "when testing a Rails app" do
    let(:rails_path) { File.join(File.expand_path("."), "rails") }

    before do
      @original_rails = Object.const_get(:Rails) if Object.const_defined?(:Rails)
      Object.const_set(:Rails, Struct.new(:root).new(rails_path))
    end

    after do
      if @original_rails
        Object.const_set(:Rails, @original_rails)
      else
        Object.send(:remove_const, :Rails)
      end
    end

    it "returns the report target directory" do
      expected = File.join(rails_path, "test/reports/hyper")
      assert_equal expected, Minitest::Hyper.report_dirname
    end

    it "returns the report target file" do
      expected = File.join(rails_path, "test/reports/hyper/index.html")
      assert_equal expected, Minitest::Hyper.report_filename
    end

    describe "when the spec/ directory is present" do
      let(:spec_dir) { File.join(rails_path, "spec") }

      before do
        FileUtils.mkdir_p(spec_dir)
      end

      after do
        FileUtils.rm_rf(rails_path)
      end

      it "returns the report target directory" do
        expected = File.join(spec_dir, "reports/hyper")
        assert_equal expected, Minitest::Hyper.report_dirname
      end

      it "returns the report target file" do
        expected = File.join(spec_dir, "reports/hyper/index.html")
        assert_equal expected, Minitest::Hyper.report_filename
      end
    end
  end

  describe "when testing a non-Rails app" do
    it "returns the report target directory" do
      expected = File.join(File.expand_path("."), "test/reports/hyper")
      assert_equal expected, Minitest::Hyper.report_dirname
    end

    it "returns the report target file" do
      expected = File.join(File.expand_path("."), "test/reports/hyper/index.html")
      assert_equal expected, Minitest::Hyper.report_filename
    end

    describe "when the spec/ directory is present" do
      let(:spec_dir) { File.join(File.expand_path("."), "spec") }

      before do
        FileUtils.mkdir(spec_dir)
      end

      after do
        FileUtils.rm_rf(spec_dir)
      end

      it "returns the report target directory" do
        expected = File.join(spec_dir, "reports/hyper")
        assert_equal expected, Minitest::Hyper.report_dirname
      end

      it "returns the report target file" do
        expected = File.join(spec_dir, "reports/hyper/index.html")
        assert_equal expected, Minitest::Hyper.report_filename
      end
    end
  end
end
