class UserController < ApplicationController
  set :rdoc, :layout_options => { :views => ENV["VIEW_PATH"] + "/layouts/layout" }
  set :views, ENV["VIEW_PATH"] + "/users"

  get "/" do
    @users = User.all

    erb :index
  end

  get "/index" do
    @users = User.all

    erb :index
  end

  get "/login" do
    erb :login
  end

  get "/signup" do
    erb :signup
  end

end
