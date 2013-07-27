require 'spec_helper'
require 'jshint/configuration'

describe Jshint::Configuration do
  let(:files) { [ 'foo/bar/**/*', 'baz.js' ] }
  let(:globals) { { :angular => true, :jQuery => true } }
  let(:opts) { { :boss => true, :browser => true } }

  let(:config) { { :files => files, :options => opts.merge(:globals => globals) } }

  describe "core behaviour" do
    before do
      described_class.any_instance.stub(:default_config_path).and_return('/foo/bar.yml')
      described_class.any_instance.stub(:parse_yaml_config).and_return(YAML.load(config.to_yaml))
    end

    it "should allow the developer to index in to config options" do
      config = described_class.new
      config[:boss].should == opts[:boss]
      config[:browser].should == opts[:browser]
    end

    it "should return a Hash of the global variables declared" do
      config = described_class.new
      config.global_variables.should == globals
    end

    it "should return a Hash of the lint options declared" do
      config = described_class.new
      config.lint_options.should == opts
    end

    it "should return an array of files" do
      config = described_class.new
      config.files.should == files
    end
  end
end
