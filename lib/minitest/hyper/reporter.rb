require "minitest"

module Minitest
  module Hyper
    class Reporter < Minitest::StatisticsReporter
      attr_accessor :all_results

      def initialize(io = $stdout, options = {})
        super
        self.all_results = []
      end

      def record(result)
        super
        all_results << result
      end

      def report
        super
        @report = Report.new(self)
        @report.write
      end

      def passed?
        super
        io.puts "Wrote HTML test report to #{ @report.url }"
      end
    end
  end
end
