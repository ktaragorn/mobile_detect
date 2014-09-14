# -*- encoding: utf-8 -*-

require File.expand_path('../lib/mobile_detect/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "mobile_detect"
  gem.version       = MobileDetect::VERSION
  gem.summary       = %q{Library to detect if the request is made from a mobile device, tablet, etc}
  gem.description   = %q{Ruby version of a php library of the same name - http://mobiledetect.net/. Intended to be a nearly complete port, sharing data exposed by the php library}
  gem.license       = "MIT"
  gem.authors       = ["Karthik T"]
  gem.email         = "karthikt.holmes+github@gmail.com"
  gem.homepage      = "https://github.com/ktaragorn/mobile_detect#readme"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'bundler', '~> 1.0'
  gem.add_development_dependency 'rake', '~> 0.8'
  gem.add_development_dependency 'rspec', '~> 2.4'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.add_development_dependency 'yard', '~> 0.8'
  gem.add_development_dependency 'rerun', '~> 0.10'
  gem.add_development_dependency 'pry'
end
