Gem::Specification.new do |s|
  s.name        = 'urbanesia'
  s.version     = '0.0.1.7'
  s.date        = '2012-12-10'
  s.summary     = "Wrapper to access the Urbanesia API"
  s.description = "Wrapper to access the Urbanesia API (docs here: http://api1.urbanesia.com/get/?manual=please ). Gem is a port of the PHP wrapper found here: https://github.com/Urbanesia/Oauthnesia"
  s.authors     = ["Michael Cho"]
  s.email       = 'michael.cho@lotuspartners.sg'
  s.files       = ["lib/urbanesia.rb", "lib/urbanesia/agent.rb"]
  s.homepage    = 'http://rubygems.org/gems/urbanesia'
  s.add_runtime_dependency "mechanize", [">= 0"]
    
end