require 'spec_helper'
require 'jshint/reporters'

describe Jshint::Reporters::Default do
  let(:results) {
    {"app/assets/javascripts/angular/controllers/feeds_controller.js"=>
    [{"id"=>"(error)",
      "raw"=>"'{a}' is not defined.",
      "code"=>"W117",
      "evidence"=>
       "app.controller(\"FeedsController\", function($scope, $rootScope, feedsService) {",
      "line"=>1,
      "character"=>1,
      "scope"=>"(main)",
      "a"=>"app",
      "b"=>nil,
      "c"=>nil,
      "d"=>nil,
      "reason"=>"'app' is not defined."},
     {"id"=>"(error)",
      "raw"=>"'{a}' is not defined.",
      "code"=>"W117",
      "evidence"=>"    angular.forEach(data, function(value, key) {",
      "line"=>13,
      "character"=>5,
      "scope"=>"(main)",
      "a"=>"angular",
      "b"=>nil,
      "c"=>nil,
      "d"=>nil,
      "reason"=>"'angular' is not defined."},
     {"id"=>"(error)",
      "raw"=>"'{a}' is defined but never used.",
      "code"=>"W098",
      "evidence"=>"    angular.forEach(data, function(value, key) {",
      "line"=>13,
      "character"=>46,
      "scope"=>"(main)",
      "a"=>"key",
      "b"=>nil,
      "c"=>nil,
      "d"=>nil,
      "reason"=>"'key' is defined but never used."}]
    }
  }
  subject { described_class.new(results) }

  it "should initialize output to be an empty string" do
    subject.output.should == ''
  end

  describe :print_footer do
    it "should output a footer starting with a new line feed" do
      subject.print_footer(3).start_with?("\n").should be_true
    end

    it "should output a footer containing '3 errors'" do
      subject.print_footer(3).should include "3 errors"
    end

    it "should output a footer containing '1 error'" do
      subject.print_footer(1).should include "1 error"
    end
  end

  describe :print_errors_for_file do
    before do
      subject.print_errors_for_file("app/assets/javascripts/angular/controllers/feeds_controller.js", results["app/assets/javascripts/angular/controllers/feeds_controller.js"])
    end

    it "should add 3 entries in to the error output" do
      subject.output.split(/\r?\n/).length.should == 3
    end

    it "should contain the line number in to the error output" do
      subject.output.should include "line 1"
    end

    it "should contain the column number in to the error output" do
      subject.output.should include "col 1"
    end

    it "should contain the filename in to the error output" do
      subject.output.should include "app/assets/javascripts/angular/controllers/feeds_controller.js"
    end

    it "should contain the nature of the error in to the error output" do
      subject.output.should include "'app' is not defined"
    end
  end
end
