require 'spec_helper'
require 'jshint/configuration'

describe Jshint::Configuration do
  let(:file) { { :include => [ 'foo/bar/**/*', 'baz.js' ] } }
  let(:yaml) { file.to_yaml }

  it "should return a hash of options when reading the contents of the passed in config file" do
    File.stub(:open).with('foo/bar.yml', 'r:UTF-8').and_return(File)
    File.stub(:read).and_return(yaml)
    config = described_class.new('foo/bar.yml')
    config.options.should == file
  end
end
