class HomeController < ApplicationController
  set :views, ENV["VIEW_PATH"] + "/home"

  get "/" do
    erb :index
  end

  get "/index" do
    erb :index
  end

end
