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

      def to_h
        HashFormatter.as_hash(self)
      end

      class HashFormatter
        def self.as_hash(reporter)
          self.new(reporter).to_h
        end

        def initialize(reporter)
          @reporter = reporter
        end

        def reporter
          @reporter
        end

        def to_h
          {
            count: reporter.count,
            assertions: reporter.assertions,
            start_time: reporter.start_time,
            total_time: reporter.total_time,
            failures: reporter.failures,
            errors: reporter.errors,
            skips: reporter.skips,
            results: result_data(reporter.all_results),
            non_passing: result_data(reporter.results)
          }
        end

        def result_data(results)
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
end
