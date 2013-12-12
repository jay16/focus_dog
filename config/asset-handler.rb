class AssetHandler < Sinatra::Base

  configure do
    enable :logging
    set :root,  ENV["APP_PATH"]
    set :views, ENV["VIEW_PATH"]
    set :rdoc, :layout_options => { :views => ENV["VIEW_PATH"] + "/layouts/layout" }
    #set :public_folder, ENV["APP_PATH"] + "/app/assets"
    set :jsdir,  ENV["APP_PATH"] +  "/app/assets/js"
    set :cssdir, ENV["APP_PATH"] + "/app/assets/css"
    #set :cssengine, "scss"
    #enable :coffeescript
    set :logging, true
    set :dump_errors, true
    set :raise_errors, true
    set :show_exceptions, true
  end

  require "database.rb"

  get "/javascripts/*.js" do
    pass unless settings.coffeescript?
    last_modified File.mtime(settings.root + "/assets/" + settings.jsdir)
    cache_control :public, :must_revalidate
    coffee (settings.jsdir + "/" + params[:splat].first).to_sym      
  end

  get "/*.css" do
    last_modified File.mtime(settings.root + "/assets/" + settings.cssdir)
    cache_control :public, :must_revalidate
    send(settings.cssengine, (settings.cssdir + "/" + params[:splat].first).to_sym)
  end

end
