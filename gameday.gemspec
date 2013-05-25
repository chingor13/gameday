$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "gameday/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "gameday"
  s.version     = Gameday::VERSION
  s.authors     = ["Jeff Ching"]
  s.email       = ["ching.jeff@gmail.com"]
  s.homepage    = "http://github.com/chingor13/gameday"
  s.summary     = "Library for pulling, parsing, and searching MLB Gameday data"
  s.description = "Library for pulling, parsing, and searching MLB Gameday data"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "tire", "~> 0.5"
  s.add_dependency "nokogiri", "~> 1.5"
end
