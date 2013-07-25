require "jshint/version"
require "jshint/railtie" if defined?(Rails)

module Jshint
  autoload :Lint, 'jshint/lint'
  autoload :Configuration, 'jshint/configuration'

  def self.root
    File.expand_path('../..', __FILE__)
  end
end
