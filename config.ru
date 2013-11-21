require 'rubygems'

ENV['RACK_ENV'] = "development"
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __FILE__)
require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
Bundler.require(:default, ENV['RACK_ENV'])

require File.expand_path("../app", __FILE__)
run Sinatra::Application
