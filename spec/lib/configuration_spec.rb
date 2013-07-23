require 'spec_helper'
require 'jshint/configuration'

describe Jshint::Configuration do
  let(:file) { { "include" => [ 'foo/bar/**/*', 'baz.js' ], "curly" => true } }
  let(:yaml) { file.to_yaml }

  before do
    described_class.any_instance.stub(:default_config_path).and_return('/foo/bar.yml')
    described_class.any_instance.stub(:read_config_file).and_return(yaml)
    described_class.any_instance.stub(:parse_yaml_config).and_return(YAML.load(yaml))
  end

  it "should fall back to the default JSHint config file when one is provided" do
    described_class.any_instance.should_receive(:default_config_path)
    config = described_class.new
    config.options.should == file
  end

  it "should return a hash of options when reading the contents of the passed in config file" do
    described_class.any_instance.should_not_receive(:default_config_path)
    config = described_class.new('/bar/baz.yml')
    config.options.should == file
  end

  it "should allow the developer to index in to config options" do
    config = described_class.new
    config[:include].should == file["include"]
    config[:curly].should == file["curly"]
  end
end
