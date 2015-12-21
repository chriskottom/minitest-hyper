require "fileutils"
require "minitest"
require "minitest/spec"

module FilesystemHelpers
  def reset_reports_directory(reports_dir)
    FileUtils.rm_rf(reports_dir) if Dir.exist?(reports_dir)
  end

  def touch_report(path)
    FileUtils.mkdir_p(File.dirname(path))
    FileUtils.touch(path)
  end
  
  module Assertions
    def assert_file(name)
      assert File.exist?(name), "#{ name } does not exist"
      assert File.file?(name), "#{ name } is not a file"
    end

    def assert_dir(name)
      assert File.exist?(name), "#{ name } does not exist"
      assert File.directory?(name), "#{ name } is not a directory"
    end

    def assert_writable(name)
      assert (File.exist?(name) && File.writable?(name)),
             "#{ name } is not writable"
    end

    def refute_file(name)
      refute (File.exist?(name) && File.file?(name)),
             "#{ name } is a file"
    end

    def refute_dir(name)
      refute (File.exist?(name) && File.directory?(name)),
             "#{ name } is a directory"
    end

    def refute_writable(name)
      assert (File.exist?(name) && File.writable?(name)),
             "#{ name } is writable"
    end
  end

  module Expectations
    include Assertions
    
    infect_an_assertion :assert_file, :must_be_a_file, :unary
    infect_an_assertion :assert_dir, :must_be_a_dir, :unary
    infect_an_assertion :assert_writable, :must_be_writable, :unary
    infect_an_assertion :refute_file, :wont_be_a_file, :unary
    infect_an_assertion :refute_dir, :wont_be_a_dir, :unary
    infect_an_assertion :refute_writable, :wont_be_writable, :unary
  end
end
