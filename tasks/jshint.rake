require 'jshint'
require 'jshint/reporters'

task :default => [:jshint]

desc "Lints the outputted application.js file from the asset pipeline"
task :jshint => :environment do
  linter = Jshint::Lint.new
  linter.lint
  reporter = Jshint::Reporters::Default.new(linter.errors)
  puts reporter.report
end
