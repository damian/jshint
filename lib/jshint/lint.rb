require "execjs"
require "multi_json"
require "jshint/configuration"

module Jshint
  # Performs the linting of the files declared in our Configuration object
  class Lint

    # @return [Hash] A Hash of errors
    attr_reader :errors

    # @return [Jshint::Configuration] The configuration object
    attr_reader :config

    # Sets up our Linting behaviour
    #
    # @param config_path [String] The absolute path to a configuration YAML file
    # @return [void]
    def initialize(config_path = nil)
      @config = Configuration.new(config_path)
      @errors = {}
    end

    # Runs JSHint over each file in our search path
    #
    # @return [void]
    def lint
      javascript_files.each do |file|
        file_content = get_file_content_as_json(file)
        code = %(
          JSHINT(#{file_content}, #{jshint_options}, #{jshint_globals});
          return JSHINT.errors;
        )
        errors[file] = context.exec(code)
      end
    end

    # Converts a Hash in to properly escaped JSON
    #
    # @param hash [Hash]
    # @return [String] The JSON outout
    def get_json(hash)
      MultiJson.dump(hash)
    end

    private

    def get_file_content(path)
      File.open(path, "r:UTF-8").read
    end

    def get_file_content_as_json(path)
      content = get_file_content(path)
      get_json(content)
    end

    def file_paths
      paths = []

      if files.is_a? Array
        files.each do |file|
          config.search_paths.each { |path| paths << File.join(path, file) }
        end
      else
        config.search_paths.each { |path| paths << File.join(path, files) }
      end

      paths
    end

    def files
      @files ||= config.files
    end

    def jshint_globals
      @jshint_globals ||= get_json(config.global_variables)
    end

    def jshint_options
      @jshint_options ||= get_json(config.lint_options)
    end

    def jshint_path
      File.join(Jshint.root, 'vendor', 'assets', 'javascripts', 'jshint.js')
    end

    def jshint
      @jshint ||= get_file_content(jshint_path)
    end

    def context
      @context ||= ExecJS.compile("var window = {};\n" + jshint)
    end

    def javascript_files
      js_asset_files = []
      file_paths.each do |path|
        Dir.glob(path) do |file|
          js_asset_files << file.reject {|file| exclude_file?(file)}
        end
      end

      js_asset_files
    end

    def exclude_file?(file)
      config.excluded_search_paths.any? {|path| file.include?(path)}
    end
  end
end
