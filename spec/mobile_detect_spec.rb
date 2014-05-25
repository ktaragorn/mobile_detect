require 'spec_helper'
require 'mobile_detect'

describe MobileDetect do
  it "should have a VERSION constant" do
    MobileDetect.const_get('VERSION').should_not be_empty
  end

  describe "Loading json data, Initialization" do
    let(:detect) {MobileDetect.new("",{})}

    it "can load the json data file" do
      expect(detect.data).to be_a(Hash)
    end

    # Just to remind me to check version
    it "is version 2.8.0 data" do
      expect(detect.data["version"]).to be_a(String)
      expect(detect.data["version"]).to start_with("2.8")
    end

    # Just to remind me to check data structure
    it "has the keys we expect" do
      expect(detect.data.keys).to eq(["version","headerMatch","uaHttpHeaders","uaMatch"])
    end

    it "initializes headers properly," do
      #  only HTTP_* is this provided this way?
      expect(detect.headers).to be_a Hash
    end
  end
end
