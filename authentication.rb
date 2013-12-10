require 'sinatra/flash'

class DmUser
  property :name, String
end

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/db/test.db")
DataMapper.auto_migrate!

set :sinatra_authentication_view_path, Pathname(__FILE__).dirname.expand_path + "authen_views/"
#use Sinatra::Session::Cookie, :secret => "heyhihello"
#use Sinatra::Flash

