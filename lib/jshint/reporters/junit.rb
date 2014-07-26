require 'rexml/text'

module Jshint::Reporters
	# Outputs a lint report in JUnit XML formt
	class Junit

		# @return [String] the report output
		attr_reader :output

		# Sets up the output string for the final report
		#
		# @param results [Hash] Key value pairs containing the filename and associated errors
		def initialize(results = {})
			@results = results
			@output = ''
		end

		# Loops through all the errors and generates the report
		#
		# @example
		#   foo/bar/baz.js: line 4, col 46, Bad operand.
		#   foo/bar/baz.js: line 39, col 7, Missing semicolon.
		#
		#   2 errors
		#
		# @return [String] The default report
		def report
			@output = <<-TEMPLATE
<?xml version="1.0" encoding="UTF-8"?>
<testsuites>
  <testsuite name="#{File.basename(Dir.pwd)}" timestamp="#{DateTime.now}">
TEMPLATE

			# Group according to the errors.
			error_groups = {}
			@results.each do |file, errors|
				errors.each do |error|
					next unless error && error['code']

					error_groups[error['code']] ||= []
					error_groups[error['code']] << {
						file: file,
						line: error['line'],
						character: error['character'],
						message: error['reason']
					}
				end
			end

			error_groups.each do |code, errors|
				print_errors_for_code(code, errors)
			end

			@output <<= <<-TEMPLATE
  </testsuite>
</testsuites>
TEMPLATE

			output
		end

		# Appends new error elements to the Report output
		#
		# @example
		#	<testcase classname="JUnitXmlReporter.constructor" name="should default path to an empty string" time="0.006">
		#	  <failure message="test failure">Assertion failed</failure>
		# </testcase>
		#
		# @param code [String] The error code
		# @param errors [Array] The errors for the code
		# @return [void]
		def print_errors_for_code(code, errors)
			name = errors.first[:message]
			output << "    <testcase classname=\"jshint.#{code}\" name=\"#{escape(name)}\">\n"
			errors.each do |error|
				output << "      <failure type=\"#{code}\" message=\"#{escape(error[:message])}\">\n"
				output << "%s, line %s, col %s: %s\n" % [
					escape(error[:file]),
					error[:line].to_s,
					error[:character].to_s,
					escape(error[:message])
				]
				output << "      </failure>\n"
			end
			output << "    </testcase>\n"
			output
		end

		# Escapes the text given for XML.
		#
		# @param text [String] The text to escape
		# @return [String]
		def escape(text)
			REXML::Text.new(text, false, nil, false).to_s
		end
	end
end
