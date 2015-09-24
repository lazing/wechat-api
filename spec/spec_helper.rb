ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'rubygems'
require "bundler"
require 'bundler/setup'

Bundler.require

require 'rspec/its'

require "faraday"
require "multi_json"

require 'webmock/rspec'
