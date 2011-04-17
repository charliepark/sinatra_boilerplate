use OmniAuth::Strategies::Twitter, CONSUMER_KEY, CONSUMER_SECRET

enable :sessions

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
