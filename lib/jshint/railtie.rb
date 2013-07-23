module Jshint
  class Railtie < Rails::Railtie
    rake_tasks do
      load "jshint/tasks/jshint.rake"
    end
  end
end
