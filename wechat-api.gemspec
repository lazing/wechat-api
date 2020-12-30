# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wechat/api/version'

Gem::Specification.new do |spec|
  spec.name          = "wechat-api"
  spec.version       = Wechat::Api::VERSION
  spec.authors       = ["Ryan Wong"]
  spec.email         = ["lazing@gmail.com"]
  spec.summary       = %q{Wechat API wrapper}
  spec.homepage      = "https://github.com/lazing/wechat-api"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'faraday', '~> 1.0'
  spec.add_runtime_dependency 'multi_json', '~> 1.0'

  spec.add_development_dependency 'bundler', '~> 1.0'
  spec.add_development_dependency 'guard', '~> 2.0'
  spec.add_development_dependency 'guard-rspec', '~> 4.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-its', '~> 1.0'
  spec.add_development_dependency 'webmock', '~> 3.0'
  
end
