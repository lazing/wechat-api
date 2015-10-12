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
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "faraday", ">= 0.9"
  spec.add_runtime_dependency "rest-client", ">= 1.7.0"
  spec.add_runtime_dependency "multi_json", ">= 1.2"
  spec.add_runtime_dependency 'gyoku', '>= 1.0.0'
  spec.add_runtime_dependency 'nori'
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 1.18"
end
