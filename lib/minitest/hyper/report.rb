require "erb"
require "fileutils"

module Minitest
  module Hyper
    class Report
      attr_reader :reporter

      def initialize(reporter)
        @reporter = reporter
      end

      def url
        "file://#{ REPORT_FILE.gsub(/\\/, "/") }"
      end

      def write
        ensure_output_dir
        move_existing_file
        write_file
      end

      private

      def ensure_output_dir
        unless Dir.exist?(REPORTS_DIR)
          FileUtils.mkdir_p REPORTS_DIR
        end
      end

      def move_existing_file
        if File.exist?(REPORT_FILE)
          ctime = File.ctime(REPORT_FILE)
          time_str = ctime.strftime("%Y%m%d%H%M%S")
          new_name = REPORT_FILE.sub(/\.html$/, "_#{ time_str }.html")
          FileUtils.mv(REPORT_FILE, new_name)
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
        File.open(REPORT_FILE, "wb") do |file|
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
