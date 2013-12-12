configure do
  DataMapper::setup(:default, "sqlite3://#{ENV['APP_PATH']}/db/default.db")

  # 加载所有models
  Dir.glob("#{ENV['APP_PATH']}/app/models/*.rb").each { |file| require file }

  # 自动迁移数据库
  DataMapper.auto_migrate!

=begin
  ["test1", "test2"].each do |name|
    User.create({:name => name,
      :email => name,
      :password => name
    })
  end
=end
end
