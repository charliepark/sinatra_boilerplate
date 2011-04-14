get '/admin' do
  if current_user and current_user.admin?
    "meep"
  else
    redirect '/'
  end
end