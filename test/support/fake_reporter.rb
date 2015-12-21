require "ostruct"

class FakeReporter < OpenStruct
  DEFAULT_OPTIONS = {
    count: 0, assertions: 0, start_time: Time.now, total_time: 0.0,
    failures: 0, errors: 0, skips: 0, results: [], non_passing: []
  }

  CODES = %i(pass skip fail error)
  
  attr_reader :all_results, :results

  def initialize(options = {})
    options = DEFAULT_OPTIONS.merge(options)
    super options
    generate_result_set
  end

  def generate_result_set
    pass_count = count >= 2 ? count * 0.5 : 1
    passes = Array.new(pass_count) { generate_result(:pass) }

    fail_count = count >= 5 ? count * 0.2 : 1
    fails = Array.new(fail_count) { generate_result(:fail) }

    error_count = count >= 5 ? count * 0.2 : 1
    errors = Array.new(error_count) { generate_result(:error) }
    
    skip_count = count >= 10 ? count * 0.1 : 1
    skips = Array.new(skip_count) { generate_result(:skip) }

    @all_results = (passes + fails + skips + errors).shuffle
    @results = (fails + skips + errors).shuffle
  end

  def to_h
    Minitest::Hyper::Reporter::HashFormatter.as_hash(self)
  end
  
  private
  
  def generate_result(type)
    result = {
      name: "Fake Name",
      code: type,
      class: type.to_s,
      outcome: type.to_s.capitalize,
      time: rand,
      assertions: rand(7)
    }
    
    if type != :pass
      failure = case type
                when :fail
                  Minitest::Assertion.new
                when :skip
                  Minitest::Skip.new
                when :error
                  begin
                    raise
                  rescue Exception => e
                    Minitest::UnexpectedError.new(e)
                  end
                end

      begin
        raise failure
      rescue Exception => e
        result[:failure] = failure
        result[:location] = failure.location
      end
    end

    OpenStruct.new result
  end
end
