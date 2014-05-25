require 'json'
class MobileDetect
  attr_reader :user_agent, :headers, :data
  def initialize(user_agent, headers)
    @user_agent = 
    @headers = headers #.select{|header| header.start_with? "HTTP_"}
    @data = load_json_data
  end

private
    def load_json_data
      File.open("data/Mobile_Detect.json", "r") do |file|  
        JSON.load(file)
      end    
    end
end