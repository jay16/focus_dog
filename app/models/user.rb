class User
    include DataMapper::Resource

    property :id, Serial
    property :name, String
    property :email, String
    property :password, String
    property :created_at, DateTime
    property :updated_at, DateTime
end
