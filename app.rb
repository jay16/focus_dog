#helper
require "#{File.dirname(__FILE__)}/helper.rb"

configure do
  set :views, "#{File.dirname(__FILE__)}/views"
  set :rdoc, :layout_options => { :views => 'views/layout' }
end

not_found do
  'This is nowhere to be found.'
end

get '/' do
  erb :index
end

get '/archive/:year/:month/:day/:tname' do |y, m, d, name|
  @datetime, @name = "#{y}#{m}#{d}", name

  erb :archive
end

get '/file/:year/:month/:day/:fname' do |y, m, d, name|
  @datetime, @name = "#{y}#{m}#{d}", name

  erb :file
end
