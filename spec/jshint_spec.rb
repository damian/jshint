require 'spec_helper'
require 'jshint'

describe Jshint do
  describe ".class methods" do
    it "should return the root path of the gem" do
      described_class.root.should == File.expand_path('../..', __FILE__)
    end
  end
end
