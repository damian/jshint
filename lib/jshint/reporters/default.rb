module Jshint::Reporters
  class Default
    attr_reader :output

    def initialize(results = [])
      @results = results
      @output = ''
    end

    def report
      len = 0
      @results.each do |file, errors|
        len += errors.length
        print_errors_for_file(file, errors)
      end
      if output
        print_footer(len)
        output
      end
    end

    def print_errors_for_file(file, errors)
      errors.map do |error|
        output << "#{file}: line #{error['line']}, col #{error['character']}, #{error['reason']}\n" unless error.nil?
      end
    end

    def print_footer(len)
      output << "\n#{len} error#{len === 1 ? nil : 's'}"
    end
  end
end
