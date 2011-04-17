get '/admin' do
  protected!
  erb :'admin/index', :layout => :'layouts/admin'
end

get '/users' do
  protected!
  @users = User.all
  erb :'admin/users', :layout => :'layouts/admin'
end
