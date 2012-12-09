require 'urbanesia/agent'

module Urbanesia
  
  mattr_accessor :consumer_key
  mattr_accessor :consumer_secret
  mattr_accessor :base_url
  
  # Makes a request to the API.
  #
  # @param [String] endpoint API endpoint according to the API docs, eg "get/super_search"
  # @param [String] post Any required post variables, eg "year=2011"
  # @param [String] get Any required get variables, eg "what=culinary&where=jakarta&row=1&offset=1000"
  # @return [String] response The output of a Mechanize agent.post to the API endpoint
  def self.request( endpoint = "get/super_search", post = "", get = "" )
    
    @agent = Agent.new(@@consumer_key, @@consumer_secret, @@base_url) if @agent.nil?
    
    return @agent.request(endpoint, post, get)
    
  end
  
end