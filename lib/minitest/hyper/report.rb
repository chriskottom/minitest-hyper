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
        test_info = {
          count: reporter.count,
          assertions: reporter.assertions,
          start_time: reporter.start_time,
          total_time: reporter.total_time,
          failures: reporter.failures,
          errors: reporter.errors,
          skips: reporter.skips,
          results: result_collection(reporter.all_results),
          non_passing: result_collection(reporter.results)
        }

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

      def result_collection(results)
        collection = []
        results.each do |result|
          collection << {
            name: result.name,
            code: result_code(result),
            class: result_class(result),
            outcome: result_string(result),
            time: result.time,
            assertions: result.assertions,
            location: result.location,
            failure: result.failure
          }
        end
        collection
      end

      def result_code(result)
        case result.failure
        when Skip
          :skip
        when UnexpectedError
          :error
        when Assertion
          :fail
        else
          :pass
        end
      end

      def result_class(result)
        result_code(result).to_s
      end

      def result_string(result)
        result_code(result).to_s.capitalize
      end
    end
  end
end
