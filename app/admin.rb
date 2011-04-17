get '/admin' do
  if current_user and current_user.admin?
    erb :admin
  else
    redirect '/'
  end
end