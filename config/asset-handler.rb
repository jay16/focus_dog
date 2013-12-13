class AssetHandler < Sinatra::Base

  configure do
    enable :logging, :static, :sessions 
    enable :dump_errors, :raise_errors, :show_exceptions
    enable :method_override

    set :root,  ENV["APP_PATH"]
    set :views, ENV["VIEW_PATH"]
    set :public_folder, ENV["APP_PATH"] + "/app/assets"
    set :js_dir,  ENV["APP_PATH"] +  "/app/assets/js"
    set :css_dir, ENV["APP_PATH"] + "/app/assets/css"

    set :erb, :layout_engine => :erb, :layout => :layout
    set :cssengine, "css"
    #enable :coffeescript
  end

  #加载数据库及model
  require "database"

end
