require 'jshint'
require 'jshint/reporters'

namespace :jshint do
  desc "Runs JSHint, the JavaScript lint tool over this project's JavaScript assets"
  task :lint => :environment do |_, args|
    # Our own argument parsing, since rake jshint will push extra nil's.
    reporter_name = :Default
    file = nil
    reporter_name = args.extras[0] if args.extras.length >= 1
    file = args.extras[1] if args.extras.length >= 2

    linter = Jshint::Lint.new
    linter.lint
    reporter = Jshint::Reporters.const_get(reporter_name).new(linter.errors)

    printer = lambda do |stream|
      stream.puts reporter.report
    end
    if file
	    Dir.mkdir(File.dirname(file))
      File.open(file, 'w') do |stream|
        printer.call(stream)
      end
    else
      printer.call($stdout)
    end

    # Return an error code of 1 if there were any errors.
    linter.errors.each do |file, errors|
      if errors.length > 0
        exit 1
      end
    end
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
