require 'json'
class MobileDetect
  attr_reader :user_agent, :http_headers, :data

  # Construct an instance of this class.
  # @param [hash] http_headers Specify the http headers of the request.
  # @param [string] user_agent Specify the User-Agent header. If null, will use HTTP_USER_AGENT
  #                        from the http_headers hash instead.

  def initialize(http_headers, user_agent = nil)
    @http_headers = http_headers #.select{|header| header.start_with? "HTTP_"}
    @user_agent = user_agent || parse_headers_for_user_agent
    @data = load_json_data
  end



  #UNIMPLEMENTED - incomplete data, property hash not provided
  # version , prepareVersionNo
  # mobileGrade

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
      ua_http_headers.map{|header| http_headers[header]}.compact.join " "
    end
end