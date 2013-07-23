require 'spec_helper'
require 'jshint'

describe Jshint::Lint do
  let(:file)          { 'foo/bar/baz.js' }
  let(:files)         { [file] }
  let(:configuration) { double("Configuration").as_null_object }
  let(:opts)          { MultiJson.dump({ :curly => true, :newcap => true }) }
  let(:globals)       { MultiJson.dump({ :jquery => true, :app => true }) }

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

  it "should respond to get_json" do
    hash = { :hello => 'world' }
    MultiJson.should_receive(:dump).with(hash)
    subject.get_json(hash)
  end

  describe :lint do
    before do
      subject.stub(:javascript_files).and_return(files)
      subject.stub(:jshint_options).and_return(opts)
      subject.stub(:jshint_globals).and_return(globals)
    end

    context "invalid file" do
      before do
        subject.stub(:get_file_content_as_json).and_return(subject.get_json(<<-eos
            var foo = "bar",
                baz = "qux",
                bat;

            if (foo == baz) bat = "gorge" // no semicolon and single line
          eos
        ))
        subject.lint
      end
      it "should add two error messages to the errors Hash" do
        subject.errors[file].length.should == 2
      end
    end

    context "valid file" do
      before do
        subject.stub(:get_file_content_as_json).and_return(subject.get_json(<<-eos
            var foo = "bar",
                baz = "qux",
                bat;

            if (foo == baz) {
              bat = "gorge";
            }
          eos
        ))
        subject.lint
      end

      it "should add two error messages to the errors Hash" do
        subject.errors[file].length.should == 0
      end
    end
  end
end
