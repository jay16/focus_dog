#helper
require %Q{#{File.dirname(__FILE__)}/helper.rb}

configure do
  set :views, %Q{#{File.dirname(__FILE__)}/views}
  set :rdoc, :layout_options => { :views => "views/layout" }
end

not_found do
  "This is nowhere to be found."
end

get "/" do
  now = Time.now - 24*60*60
  ymd = now.strftime("%y/%m/%d")

  redirect %Q{/archive/#{ymd}/report}
end

get "/archive/:year/:month/:day/:tname" do |y, m, d, name|
  @datetime, @name = %Q{#{y}#{m}#{d}}, name

  erb :archive
end

get "/file/:year/:month/:day/:fname" do |y, m, d, name|
  @ymd, @datetime, @name = %Q{#{y}/#{m}/#{d}}, %Q{#{y}#{m}#{d}}, name

  erb :file
end
