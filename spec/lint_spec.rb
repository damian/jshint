require 'spec_helper'
require 'jshint'

describe Jshint::Lint do
  it "should contain a refernce to all the directories under which Rails assets can be served" do
    described_class::RAILS_ASSET_PATHS.should == ['app', 'vendor', 'lib']
  end


end
