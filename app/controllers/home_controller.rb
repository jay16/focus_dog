class HomeController < ApplicationController
  set :rdoc, :layout_options => { :views => ENV["VIEW_PATH"] + "/layouts/layout" }
  set :views, ENV["VIEW_PATH"] + "/home"

  get "/" do
    erb :index
  end

  get "/index" do
    erb :index
  end

end
