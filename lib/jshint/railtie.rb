module Jshint
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.expand_path("../../../tasks/jshint.rake", __FILE__)
    end
  end
end
