require "erb"
require "fileutils"

module Minitest
  module Hyper
    class Report
      attr_reader :reporter

      def initialize(reporter)
        @reporter = reporter
      end

      def write
        ensure_output_dir
        move_existing_file
        write_file
      end

      def url
        "file://#{ filename.gsub(/\\/, "/") }"
      end

      def dirname
        Minitest::Hyper.report_dirname
      end

      def filename
        Minitest::Hyper.report_filename
      end

      private

      def ensure_output_dir
        unless Dir.exist?(dirname)
          FileUtils.mkdir_p dirname
        end
      end

      def move_existing_file
        if File.exist?(filename)
          ctime = File.ctime(filename)
          time_str = ctime.strftime("%Y%m%d%H%M%S")
          new_name = filename.sub(/\.html$/, "_#{ time_str }.html")
          FileUtils.mv(filename, new_name)
        end
      end

      def write_file
        page_info = {
          title: "Minitest::Hyper Test Report",
          styles: css_string,
          timestamp: Time.now
        }
        test_info = reporter.to_h

        erb = ERB.new(template_string)
        File.open(filename, "wb") do |file|
          file.write erb.result(binding)
        end
      end

      def css_string
        File.read(CSS_TEMPLATE)
      end

      def template_string
        File.read(HTML_TEMPLATE)
      end
    end
  end
end
