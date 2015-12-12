require "fileutils"

module Minitest
  module Hyper
    class Report
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
        FileUtils.touch(REPORT_FILE)
      end
    end
  end
end
