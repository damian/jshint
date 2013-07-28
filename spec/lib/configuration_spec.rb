require 'spec_helper'
require 'jshint/configuration'

describe Jshint::Configuration do
  let(:config) { File.join(Jshint.root, 'spec', 'fixtures', 'jshint.yml') }

  describe "core behaviour" do
    before do
      described_class.any_instance.stub(:default_config_path).and_return('/foo/bar.yml')
      described_class.any_instance.stub(:parse_yaml_config).and_return(YAML.load_file(config))
    end

    it "should allow the developer to index in to config options" do
      config = described_class.new
      config[:boss].should be_true
      config[:browser].should be_true
    end

    it "should return a Hash of the global variables declared" do
      config = described_class.new
      config.global_variables.should == { "jQuery" => true, "$" => true }
    end

    it "should return a Hash of the lint options declared" do
      config = described_class.new
      config.lint_options.should == config.options["options"].reject { |key| key == "globals" }
    end

    it "should return an array of files" do
      config = described_class.new
      config.files.should == ["**/*.js"]
    end
  end
end
