require 'jshint'
require 'jshint/reporters'

namespace :jshint do
  desc "Runs JSHint, the JavaScript lint tool over this project's JavaScript assets"
  task :lint, [:reporter] => :environment do |_, args|
	  args.with_defaults(reporter: :Default)

    linter = Jshint::Lint.new
    linter.lint
    reporter = Jshint::Reporters.const_get(args.reporter).new(linter.errors)
    puts reporter.report
  end

  desc "Copies the default JSHint options to your Rails application"
  task :install_config => :environment do
    source_file = File.join(Jshint.root, 'config', 'jshint.yml')
    source_dest = File.join(Rails.root, 'config', '')
    FileUtils.cp(source_file, source_dest)
  end
  task :all => [:lint]
end

desc "Runs JSHint, the JavaScript lint tool over this projects JavaScript assets"
task :jshint => ["jshint:all"]
