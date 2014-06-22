require 'json'
class MobileDetect
  attr_reader :http_headers, :data
  attr_accessor :user_agent

  # Construct an instance of this class.
  # @param [hash] http_headers Specify the http headers of the request.
  # @param [string] user_agent Specify the User-Agent header. If null, will use HTTP_USER_AGENT
  #                        from the http_headers hash instead.

  def initialize(http_headers, user_agent = nil)
    @http_headers = http_headers.select{|header| header.start_with? "HTTP_"}
    @user_agent = user_agent || parse_headers_for_user_agent
    @data = load_json_data
  end



  #UNIMPLEMENTED - incomplete data, property hash and utilities hash not provided
  # version , prepareVersionNo
  # mobileGrade
  # detection mode (deprecated in MobileDetect)

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

    [:phones, :tablets, :browsers, [:os, :operating_systems]].each do |(key,func)|
      func ||=key
      define_method :func do
        data["uaMatch"][key]
      end
    end

    def rules
      @rules ||= phones + tablets + browsers + operating_systems
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

    def match regex, ua_string = user_agent
      # Escape the special character which is the delimiter.
      regex.gsub!("/", "\/")
      !! ua_string =~ /#{regex}/
    end
end