require 'spec_helper'
require 'jshint'

describe Jshint::Lint do
  let(:configuration) { double("Configuration").as_null_object }
  let(:assets) { double("Assets").as_null_object }

  subject do
    Jshint::Configuration.stub(:new).and_return(configuration)
    described_class.new
  end

  it "should initialize errors to an empty Hash" do
    subject.errors.should be_a Hash
  end

  it "should assing the Configration object to config" do
    subject.config.should == configuration
  end

  describe :lint do
    before do
      subject.stub(:js_files).and_return(['foo/**/*.js', 'baz.js'])
      File.stub(:read).and_return('var foo = "bar"');
      Rails.application.class.stub(:assets).and_return(assets)
    end

    it "should add two error messages to the errors Hash" do
      subject.lint
      subject.errors.length.should == 2
    end
  end

end
