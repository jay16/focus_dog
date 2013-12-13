class UserController < ApplicationController
  set :rdoc, :layout_options => { :views => ENV["VIEW_PATH"] + "/layouts/layout" }
  set :views, ENV["VIEW_PATH"] + "/users"

  get "/" do
    @users = User.all

    erb :index
  end

  #index - 用户列表
  get "/index" do
    @users = User.all

    erb :index
  end

  #new - 注册
  get "/signup" do
    @user = User.new

    erb :signup
  end

  #create - 用户创建
  post "/create" do
    @user = User.new(params[:user])

    if user.save
      redirect "/users/login"
    else
      redirect "/users/signup"
    end
  end


  #登陆
  get "/login" do
    erb :login
  end

  #edit - 编辑
  get "/:id" do |id|
    @user = User.get!(id)

    erb :login
  end

  #update - 更新
  put "/:id" do |id|
    @user = User.get!(id)
    state = @user.update!(params[:user])
 
    erb :login
  end

  #delete - 删除
  delete "/:id" do |id|
    user = User.get!(id)
    user.destroy! 

    redirect "/users"
  end

end
