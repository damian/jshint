module Jshint
  module Cli
    def run(reporter_name = :Default, result_file = nil)
      linter = Jshint::Lint.new
      linter.lint
      reporter = Jshint::Reporters.const_get(reporter_name).new(linter.errors)

      printer = lambda do |stream|
        stream.puts reporter.report
      end

      if result_file
        Dir.mkdir(File.dirname(file))
        File.open(file, 'w') do |stream|
          printer.call(stream)
        end
      else
        printer.call($stdout)
      end
    end
  end
end
