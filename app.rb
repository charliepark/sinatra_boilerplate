%w(rubygems oa-oauth dm-core dm-sqlite-adapter dm-migrations sanitize sinatra).each { |dependency| require dependency }

require 'oauth_passwords'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/database.db")

class User
  include DataMapper::Resource
  property :id,         Serial
  property :uid,        String
  property :name,       String
  property :nickname,   String
  property :created_at, DateTime
end

DataMapper.finalize
DataMapper.auto_upgrade!

use OmniAuth::Strategies::Twitter, CONSUMER_KEY, CONSUMER_SECRET

enable :sessions

helpers do
  def current_user
    @current_user ||= User.get(session[:user_id]) if session[:user_id]
  end
end

get '/' do
  if current_user
    erb :index
  else
    erb :index_public
  end
end

get '/auth/:name/callback' do
  auth = request.env["omniauth.auth"]
  user = User.first_or_create({ :uid => auth["uid"]}, { :uid => auth["uid"], :nickname => auth["user_info"]["nickname"], :name => auth["user_info"]["name"], :created_at => Time.now })
  session[:user_id] = user.id
  redirect '/'
end

# any of the following routes should work to sign the user in: /sign_up, /signup, /sign_in, /signin, /log_in, /login
["/sign_in/?", "/signin/?", "/log_in/?", "/login/?", "/sign_up/?", "/signup/?"].each do |path|
  get path do
    redirect '/auth/twitter'
  end
end

# either /log_out, /logout, /sign_out, or /signout will end the session and log the user out
["/sign_out/?", "/signout/?", "/log_out/?", "/logout/?"].each do |path|
  get path do
    session[:user_id] = nil
    redirect '/'
  end
end


enable :inline_templates

__END__

@@ layout
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Page Title</title>
    <style type="text/css">
      html,body,div,span,applet,object,iframe,h1,h2,h3,h4,h5,h6,p,blockquote,pre,a,abbr,acronym,address,big,cite,code,del,dfn,em,font,img,ins,kbd,q,s,samp,small,strike,strong,sub,sup,tt,var,b,u,i,center,dl,dt,dd,ol,ul,li,fieldset,form,label,legend,table,caption,tbody,tfoot,thead,tr,th,td{margin:0;padding:0;border:0;outline:0;font-size:100%;vertical-align:baseline;background:transparent}body{line-height:1}ol,ul{list-style:none}blockquote,q{quotes:none}blockquote:before,blockquote:after,q:before,q:after{content:'';content:none}:focus{outline:0}ins{text-decoration:none}del{text-decoration:line-through}table{border-collapse:collapse;border-spacing:0}article, aside, details, figcaption, figure, footer, header, hgroup, menu, nav, section{display:block}
      body, button, input, select, textarea{font-family:'lucida grande', 'helvetica neue',helvetica,arial,sans-serif;font-size:12px;line-height:20px}td{border-top:1px solid #ccc;padding:0 10px}th{font-weight:bold}
      body{margin:0 auto;width:960px;}
    </style>
  </head>
  <body>
  <div id="header"><h1>App Name</h1></div>
<%= yield %>
  </body>
</html>

@@ index
    <p>This is the logged-in page.</p>

@@ index_public
    <a href="/sign_up">create an account</a> or <a href="/sign_in">sign in with Twitter</a>
