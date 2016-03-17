require 'spec_helper'

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
      expect(detect.data.keys).to include("version","headerMatch","uaHttpHeaders","uaMatch")
    end

    it "initializes headers properly," do
      #  only HTTP_* is this provided this way?
      expect(detect.http_headers).to be_a Hash
    end
  end

  describe "Test basic methods" do
    let(:test_ua){"'Mozilla/5.0 (iPhone; CPU iPhone OS 6_0_1 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A523 Safari/8536.25'"}
    let(:test_headers){{
      'SERVER_SOFTWARE' => 'Apache/2.2.15 (Linux) Whatever/4.0 PHP/5.2.13',
      'REQUEST_METHOD' => 'POST',
      'HTTP_HOST' => 'home.ghita.org',
      'HTTP_X_REAL_IP' => '1.2.3.4',
      'HTTP_X_FORWARDED_FOR' => '1.2.3.5',
      'HTTP_CONNECTION' => 'close',
      'HTTP_USER_AGENT' => 'Mozilla/5.0 (iPhone; CPU iPhone OS 6_0_1 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A523 Safari/8536.25',
      'HTTP_ACCEPT' => 'text/vnd.wap.wml, application/json, text/javascript, */*; q=0.01',
      'HTTP_ACCEPT_LANGUAGE' => 'en-us,en;q=0.5',
      'HTTP_ACCEPT_ENCODING' => 'gzip, deflate',
      'HTTP_X_REQUESTED_WITH' => 'XMLHttpRequest',
      'HTTP_REFERER' => 'http://mobiledetect.net',
      'HTTP_PRAGMA' => 'no-cache',
      'HTTP_CACHE_CONTROL' => 'no-cache',
      'REMOTE_ADDR' => '11.22.33.44',
      'REQUEST_TIME' => '01-10-2012 07:57'
    }}
    let(:detect_with_constructor){
      MobileDetect.new(test_headers, test_ua)
    }
    let(:detect_with_methods){
      m = MobileDetect.new
      m.http_headers = test_headers
      m.user_agent = test_ua
      m
    }

    def basic_methods_test(detector)
      # $this->assertNotEmpty( $this->detect->getUserAgent() );
      # $this->assertTrue( $this->detect->isMobile() );
      # $this->assertFalse( $this->detect->isTablet() );
      # $this->assertTrue( $this->detect->isIphone() );
      # $this->assertTrue( $this->detect->isiphone() );
      # $this->assertTrue( $this->detect->isiOS() );
      # $this->assertTrue( $this->detect->isios() );
      # $this->assertTrue( $this->detect->is('iphone') );
      # $this->assertTrue( $this->detect->is('ios') );
      expect(detector.user_agent).to_not be_empty
      expect(detector.mobile?).to be_truthy
      expect(detector.tablet?).to be_falsey
      expect(detector.Iphone?).to be_truthy
      expect(detector.iphone?).to be_truthy
      expect(detector.ios?).to be_truthy
      expect(detector.IoS?).to be_truthy
      expect(detector.is?("iphone")).to be_truthy
      expect(detector.is?("ios")).to be_truthy
    end

    it "can perform basic methods when constructed" do
      basic_methods_test(detect_with_constructor)
    end

    it "can perform basic methods when set by methods" do
      basic_methods_test(detect_with_methods)
    end

    context 'when headers are symbols' do
      let(:test_headers) do
        {
          HTTP_USER_AGENT:      'Mozilla/5.0 (iPhone; CPU iPhone OS 6_0_1 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A523 Safari/8536.25',
          HTTP_ACCEPT:          'text/vnd.wap.wml, application/json, text/javascript, */*; q=0.01',
          HTTP_ACCEPT_LANGUAGE: 'en-us,en;q=0.5',
          HTTP_ACCEPT_ENCODING: 'gzip, deflate'
        }
      end

      it 'converts headers keys to strings' do
        basic_methods_test(detect_with_constructor)
      end
    end

    context 'when user agent contains unicode characters' do
      it 'does not crash' do
        user_agent = "Mozilla/5.0 (iPhone; CPU iPhone OS 9_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13E5225a [FBAN/FBIOS;FBAV/50.0.0.47.191;FBBV/23973043;FBDV/iPad6,8;FBMD/iPad;FBSN/iPhone OS;FBSV/9.3;FBSS/2; FBCR/\u4e2d\u56fd\u8054\u901a;FBID/tablet;FBLC/en_US;FBOP/1]"

        detect = MobileDetect.new({}, user_agent)

        expect do
          detect.tablet?
        end.to_not raise_error
      end
    end
  end

  describe "Testing the User Agent" do
    let(:detector) { MobileDetect.new({})}
    user_agents = JSON.load(File.open("spec/ualist.json", "r"))["user_agents"]

    user_agents.each do |test|
      # Not sure why, but skip ones that have model
      # Copied comment over
      # Currently not supporting version and model here.
      # @todo: I need to split this tests!?

      next if test.key? "model"

      it "detects the UA string correctly for UA - #{test["user_agent"]}" do
        detector.user_agent = test["user_agent"]

        # version key not supported cuz hash not provided
        expect(detector.mobile?).to eq test["mobile"] if test.key? "mobile"
        expect(detector.tablet?).to eq test["tablet"] if test.key? "tablet"
      end
    end
  end
end
