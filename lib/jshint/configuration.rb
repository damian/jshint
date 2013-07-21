require 'yaml'

module Jshint
  class Configuration
    attr_reader :options

    def initialize(path = nil)
      @path = path || default_config_path
      @options = convert_config_to_hash
    end

    private

    def read_config_file
      @read_config_file ||= File.open(@path, 'r:UTF-8').read
    end

    def convert_config_to_hash
      YAML.load(read_config_file)
    end

    def default_config_path
      File.join(Rails.root, 'config', 'jshint.yml')
    end
  end
end
