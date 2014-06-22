require 'spec_helper'
require 'mobile_detect'

describe MobileDetect do
  it "should have a VERSION constant" do
    MobileDetect.const_get('VERSION').should_not be_empty
  end

  describe "Loading json data, Initialization" do
    let(:detect) {MobileDetect.new({},{})}

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
      expect(detect.http_headers).to be_a Hash
    end
  end

  describe "Testing the User Agent" do
    let(:detector) { MobileDetect.new({})}
    let(:user_agents){ JSON.load(File.open("spec/ualist.json", "r"))["user_agents"]}
    it "detects the UA string correctly" do
      user_agents.each do |test|
        detector.user_agent = test["user_agent"]

        # Not sure why, but skip ones that have model
        # Copied comment over
        # Currently not supporting version and model here.
        # @todo: I need to split this tests!

        next if test.key? "model"

        # version key not supported cuz hash not provided

        if test.key? "mobile"
          expect(detector.mobile?).to equal test["mobile"]
        end

        if test.key? "tablet"
          expect(detector.tablet?).to equal test["mobile"]
        end

      end
    end
  end
end
