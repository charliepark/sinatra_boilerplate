%w(rubygems dm-core dm-migrations dm-sqlite-adapter oa-oauth sanitize sinatra).each { |dependency| require dependency }

set :views, 'app/views'
set :session_secret, 'all my best friends are metalheads'

require 'config/requirements'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/database.db")

class User
  include DataMapper::Resource
  property :id,         Serial
  property :uid,        String
  property :name,       String
  property :nickname,   String
  property :created_at, DateTime

  @@admin_users = ADMIN_UIDS

  def admin?
    @@admin_users.include?(uid.to_s)
  end
end

DataMapper.finalize
DataMapper.auto_upgrade!

get '/' do
  if current_user
    erb :index
  else
    erb :index_public
  end
end