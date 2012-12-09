require 'mechanize'

module Urbanesia

  class Agent

    def initialize(consumer_key, consumer_secret, base_url)
      
      raise ArgumentError, "Missing Consumer Key: Add Urbanesia.consumer_key = 'your-key-here' to an initializer" if consumer_key.nil? or consumer_key == 0
      @consumer_key = consumer_key
      
      raise ArgumentError, "Missing Consumer Secret: Add Urbanesia.consumer_secret = 'your-secret-here' to an initializer" if consumer_secret.nil? or consumer_secret == 0
      @consumer_secret = consumer_secret
      
      @base_url = base_url || "http://api1.urbanesia.com/"
    end
    
    def request( endpoint = "get/super_search", post = "", get = "" )
      
      start_time = Time.now # eg Time.parse('2012-12-08 09:00:03 UTC') 
      @time = start_time.to_f.to_s # eg 1354975291
      @nonce = self.generate_nonce( @time )
      
      post = self.generate_default_post(post)
      
      requestify = self.requestify(post + "&" + get)
      oauth_signature = self.generate_oauth_signature(endpoint, requestify)
      
      #### Note:
      #### get should have replaced "," with "%2C" but I didn't put it into a separate 
      #### string. This is the same process in the self.requestify method.
      #### Check this line first if any errors.
      final_url = @base_url + endpoint + oauth_signature + "&" + get   
          
      agent = Mechanize.new
      
      response = agent.post(final_url, 
        "oauth_consumer_key" => @consumer_key,
        "oauth_nonce" => @nonce,
        "oauth_signature_method" => "HMAC-SHA1",
        "oauth_timestamp" => @time,
        "oauth_version" => "1.0",
        "safe_encode" => 1
      ).content      
      
      return response
      
    end
    
    # The "nonce" is a string based on a timestamp, eg 946eeff5e43578078c746bb1df62145d
    # The API is limited to one request per nonce. 
    def generate_nonce(time = Time.now)
      return Digest::MD5.hexdigest( time )
    end
    
    # Combine any user-inputted post variables with the default post variables required for the API call.
    def generate_default_post(post)
      default_post = "oauth_consumer_key=" + @consumer_key + "&oauth_nonce=" + @nonce + "&oauth_signature_method=HMAC-SHA1&oauth_timestamp=" + @time + "&oauth_version=1.0&safe_encode=1" 
      default_post += "&" + post unless post.nil? or post == "" 
      return default_post 
    end
    
    # Encode POST and GET for OAUTH
    # Sort GET + POST into 1 string, sorted by param key    
    def requestify(vars)
      arr = vars.split("&").sort!
      requestify = ""
      arr.each do |e|
        requestify << "&" if !e.eql?(arr.first)
        tmp = e.split("=")
        requestify << CGI.escape(tmp[0]).gsub("+", "%20") + "=" + CGI.escape(tmp[1]).gsub("+", "%20")
      end      
      return requestify    
    end
    
    # The Oauth Signature is an encryption of the post/get variables and timestamp
    # The API uses this to check that the API call is valid.
    def generate_oauth_signature(endpoint, requestify)
      base_sig = "POST&" + CGI.escape(@base_url + endpoint).gsub("+", "%20") + "&" + CGI.escape(requestify).gsub("+", "%20")
      digest = OpenSSL::Digest::Digest.new('sha1')
      oauth_sig = OpenSSL::HMAC.digest(digest, @consumer_secret + "&", base_sig )
      oauth_sig = Base64.encode64( oauth_sig ).chomp.gsub(/\n/,'') # eg 2j16OUZpkwcj9oogIIPgIJhOI4Q=
      oauth_sig = oauth_sig.gsub("=", "%3D")
      oauth_sig = oauth_sig.gsub("+", "%2B") # eg OTg2N2I2YWIxZWFhOGNmNGYwNWM1Y2NkMTM1Mzc0YjFlMWE4MjE0Zg%3D%3D
      oauth_sig = "?oauth_signature=" + oauth_sig  
      return oauth_sig     
    end
    
  end
    
end
