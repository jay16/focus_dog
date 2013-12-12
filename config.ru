require "rubygems"

ENV["RACK_ENV"] = "development"
ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __FILE__)
require "bundler/setup" if File.exists?(ENV["BUNDLE_GEMFILE"])
Bundler.require(:default, ENV["RACK_ENV"])

ENV["APP_PATH"] = Dir.pwd
ENV["VIEW_PATH"] = Dir.pwd + "/app/views/"

$:.unshift(File.join(Dir.pwd,"config"))

%w(controllers helpers models).each do |path|
  $:.unshift(File.join(Dir.pwd,"app",path))
end


#config文夹下为配置信息优先加载
require "asset-handler"

#helper在controller中被调用，优先于controller
require "application_helper"
require "user_helper"

#controller,基类application_controller.rb
require "application_controller"
require "home_controller"
require "user_controller"

#定义router前缀
map("/users") { run UserController }
map("/") { run HomeController }
