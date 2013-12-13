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
    @action = "/users"

    erb :form
  end

  #create - 创建
  post "/" do
    user = User.new(params[:user])

    if user.save
      redirect "/users"
    else
      redirect "/users/signup"
    end
  end


  #登陆
  get "/login" do
    erb :login
  end

  #show - 明细
  get "/:id" do |id|
    @user = User.get!(id)

    erb :show
  end

  #edit - 编辑
  get "/:id/edit" do |id|
    @user = User.get!(id)
    @action = "/users/#{id}/update"
 
    erb :form
  end

  #update - 更新
  post "/:id/update" do |id|
    @user = User.get!(id)
    state = @user.update!(params[:user])
 
    if state
      redirect "/users"
    else
      redirect "/users/#{id}/edit"
    end
  end

  #delete - 删除
  delete "/:id" do |id|
    user = User.get!(id)
    user.destroy! 

    redirect "/users"
  end

end
