require "jshint"
require "jshint/version"
require "jshint/engine" if defined?(Rails)
require "jshint/railtie" if defined?(Rails)

module Jshint
  autoload :Lint, 'jshint/lint'
end
