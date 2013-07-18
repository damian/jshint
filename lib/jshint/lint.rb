require "execjs"
require "multi_json"

module Jshint
  class Lint
    attr_reader :errors, :config

    RAILS_ASSET_PATHS = %W{app vendor assets}

    def initialize(file_paths = [], config_path = nil)
      @config_path = config_path || File.join(Rails.root, '.jshintrc')
      @errors = {}
      @js_asset_paths = parse_file_paths
    end

    def lint
      js_files.each do |file|
        file_content = MultiJson.dump(File.read(file))
        code = %(
          JSHINT(#{file_content}, #{jshint_opts}, #{jshint_globals});
          return JSHINT.errors;
        )
        errors[file] = context.exec(code)
      end
    end

    private

    def setup_rails_js_asset_paths
      RAILS_ASSET_PATHS.dup.map { |path| File.join(Rails.root, path, 'assets', 'javascripts') }
    end

    def parse_file_paths
      paths = setup_rails_js_asset_paths
      if files.is_a? Array
        files.each do |file|
          paths = paths.map { |path| File.join(path, file) }
        end
      else
        paths = paths.map { |path| File.join(path, files) }
      end

      paths
    end

    def files
      @files ||= config[:files]
    end

    def config
      @config ||= MultiJson.load(File.open(@config_path, 'r:UTF-8').read, :symbolize_keys => true)
    end

    def jshint_globals
      @jshint_globals ||= MultiJson.dump(config[:options][:globals])
    end

    def jshint_opts
      @jshint_opts ||= MultiJson.dump(config[:options].slice!(:globals))
    end

    def jshint
      @jshint ||= asset_paths.find_asset('jshint')
    end

    def asset_paths
      @asset_paths ||= Rails.application.class.assets
    end

    def jshint_file
      @jshint_file ||= File.open(jshint.pathname, "r:UTF-8").read
    end

    def context
      @context ||= ExecJS.compile("var window = {};\n" + jshint_file)
    end

    def js_files
      js_asset_files = []
      @js_asset_paths.each do |path|
        Dir.glob(path) do |file|
          js_asset_files << file
        end
      end

      js_asset_files
    end

  end
end
