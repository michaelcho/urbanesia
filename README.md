# urbanesia

urbanesia is a wrapper to access the Urbanesia API.

Urbanesia is an Indonesian directory site with [API docs][api_docs] available online. 

To use this gem, you will need to [apply for a consumer key and secret][apply_keys]. 

This gem is a port of the [PHP wrapper][php_wrapper]. The PHP wrapper has some methods relating to a user key and user secret (as well as the consumer key/secret) but I did not have to use these at all so did not include them in this gem.

## Installation
``` ruby
gem "urbanesia", "~> 0.0.1.7"
```

Create a initializers/urbanesia.rb file:
``` ruby
Urbanesia.consumer_key = "your-key-here"
Urbanesia.consumer_secret = "your-secret-here"
```

That's it!

## Usage
You can use the Urbanesia module in any controller.

I use it in a rake task, and include "require 'urbanesia'", ie

``` ruby
require 'urbanesia'
response = Urbanesia.request "get/super_search", "", "what=culinary&where=jakarta"

# response can now be treated as a normal string, eg
parsed_json = JSON.parse CGI.unescapeHTML(response)
unless parsed_json.blank? || parsed_json["biz_profile"].blank?
  restaurants = parsed_json["biz_profile"]
end
``` 
  

[api_docs]: http://api1.urbanesia.com/get/?manual=please
[apply_keys]: http://www.urbanesia.com/auth/registrato/
[php_wrapper]: https://github.com/Urbanesia/Oauthnesia
