class ApplicationController < Sinatra::Base

  register Sinatra::Reloader

  helpers ApplicationHelper
  helpers Sinatra::FormHelpers
  
  enable :sessions, :logging, :dump_errors, :raise_errors, :static, :method_override

  #register Sinatra::Auth
  #register Sinatra::Flash

  #css/js/view配置文档
  use AssetHandler

  not_found{ erb "shared/not_found" }
  
end
