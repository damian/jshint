require 'jshint'
require 'jshint/reporters'

task :default => [:jshint]

desc "Runs JSHint, the JavaScript lint tool over this projects JavaScript assets"
task :jshint => :environment do
  linter = Jshint::Lint.new
  linter.lint
  reporter = Jshint::Reporters::Default.new(linter.errors)
  puts reporter.report
end
