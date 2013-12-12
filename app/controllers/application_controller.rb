class ApplicationController < Sinatra::Base
  helpers ApplicationHelper
  
  enable :sessions, :method_override

  #register Sinatra::Auth
  #register Sinatra::Flash

  #css/js/view配置文档
  use AssetHandler


  not_found{ erb "shared/not_found" }
  
end
