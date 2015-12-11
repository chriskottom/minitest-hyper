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
      end

      def passed?
        super
      end
    end
  end
end
