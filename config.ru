require "rubygems"

ENV["RACK_ENV"] = "development"
ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __FILE__)
require "bundler/setup" if File.exists?(ENV["BUNDLE_GEMFILE"])
Bundler.require(:default, ENV["RACK_ENV"])

ENV["APP_PATH"] = Dir.pwd
ENV["VIEW_PATH"] = Dir.pwd + "/app/views/"

#扩充require路径数组
#require 文件时会在$:数组中查找是否存在
$:.unshift(File.join(Dir.pwd,"config"))
%w(controllers helpers models).each do |path|
  $:.unshift(File.join(Dir.pwd,"app",path))
end


#config文夹下为配置信息优先加载
#modle信息已在asset-hanler中加载
#asset-hanel嵌入在application_controller
require "asset-handler"

%w(application home user).each do |part|
  #helper在controller中被调用，优先于controller
  require "#{part}_helper"

  #controller,基类application_controller.rb
  #application_controller.rb最先被引用
  require "#{part}_controller"
end

#自定义匹配router前缀
#route越复杂越前置，越模糊越后置
map("/users") { run UserController }
map("/") { run HomeController }
