require 'json'

class MobileDetect
  attr_reader :http_headers, :data
  attr_writer :user_agent

  # Construct an instance of this class.
  # @param [hash] http_headers Specify the http headers of the request.
  # @param [string] user_agent Specify the User-Agent header. If null, will use HTTP_USER_AGENT
  #                        from the http_headers hash instead.

  def initialize(http_headers = {}, user_agent = nil)
    @data = load_json_data
    self.http_headers = http_headers
    self.user_agent = user_agent
  end

  #UNIMPLEMENTED - incomplete data, property hash and utilities hash not provided
  # version , prepareVersionNo
  # mobileGrade
  # detection mode (deprecated in MobileDetect)

  #not including deprecated params
  #Check if the device is mobile.
  #Returns true if any type of mobile device detected, including special ones
  #@return bool
  def mobile?
    (check_http_headers_for_mobile or
    match_detection_rules_against_UA)
  end

  #set the hash of http headers, from env in rails or sinatra
  #used to get the UA and also to get some mobile headers
  def http_headers=(env)
    @http_headers = env.select{|header, value| header.start_with? "HTTP_"}
  end

  #To access the user agent, retrieved from http_headers if not explicitly set
  def user_agent
    @user_agent ||= parse_headers_for_user_agent

    raise "User agent needs to be set before this module can function" unless @user_agent

    @user_agent
  end

  #Check if the device is a tablet.
  #Return true if any type of tablet device is detected.
  #not including deprecated params
  #@return bool
  def tablet?
    match_detection_rules_against_UA tablets
  end

  # Checks if the device is conforming to the provided key
  # e.g detector.is?("ios") / detector.is?("androidos") / detector.is?("iphone")
  # @return bool
  def is?(key)
    # Make the keys lowercase so we can match: is?("Iphone"), is?("iPhone"), is?("iphone"), etc.
    key = key.downcase

    lc_rules = Hash[rules.map do |k, v|
      [k.downcase, v.downcase]
    end]

    unless lc_rules[key]
      raise NoMethodError, "Provided key, #{key}, is invalid"
    end

    match lc_rules[key]
  end

  # Checks if the device is conforming to the provided key
  # e.g detector.ios? / detector.androidos? / detector.iphone?
  # @return bool
  def method_missing(name, *args, &blk)
    unless(Array(args).empty?)
      puts "Args to #{name} method ignored"
    end

    unless(name[-1] == "?")
      super
    end

    is? name[0..-2]
  end

private
    def load_json_data
      File.open("data/Mobile_Detect.json", "r") do |file|
        JSON.load(file)
      end
    end

    def ua_http_headers
      data["uaHttpHeaders"]
    end

    # Parse the headers for the user agent - uses a list of possible keys as provided by upstream
    # @return (String) A concatenated list of possible user agents, should be just 1
    def parse_headers_for_user_agent
      ua_http_headers.map{|header| http_headers[header]}.compact.join(" ").strip
    end

    ["phones", "tablets", "browsers", ["os", "operating_systems"]].each do |(key,func)|
      func ||=key
      define_method func do
        data["uaMatch"][key]
      end
    end

    def rules
      @rules ||= phones.merge(tablets.merge(browsers.merge(operating_systems)))
    end

    # Check the HTTP headers for signs of mobile.
    # This is the fastest mobile check possible; it's used
    # inside isMobile() method.
    #
    # @return bool
    def check_http_headers_for_mobile
      data["headerMatch"].each do |mobile_header, match_type|
        if(http_headers[mobile_header])
          return false if match_type.nil? || !match_type["matches"].is_a?(Array)

          Array(match_type["matches"]).each do |match|
            return true if http_headers[mobile_header].include? match
          end

          return false
        end
      end
      false
    end

    # Some detection rules are relative (not standard),
    # because of the diversity of devices, vendors and
    # their conventions in representing the User-Agent or
    # the HTTP headers.

    # This method will be used to check custom regexes against
    # the User-Agent string.
    # @return bool
    def match key_regex, ua_string = user_agent
      # Escape the special character which is the delimiter.
      # _, regex = key_regex
      regex = Array(key_regex).last # accepts a plain regex or a pair of key,regex
      regex.gsub!("/", "\/")
      !! (ua_string =~ /#{regex}/is)
    end

    #Find a detection rule that matches the current User-agent.
    #not including deprecated params
    #@return bool
    def match_detection_rules_against_UA rules = rules
      # not sure why the empty check is needed here.. not doing it
      rules.each do |regex|
        return true if match regex
      end
      false
    end
end