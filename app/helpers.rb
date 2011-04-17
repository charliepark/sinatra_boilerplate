helpers do
  def current_user
    @current_user ||= User.get(session[:user_id]) if session[:user_id]
  end
  
  def protected!
    redirect '/' unless current_user and current_user.admin?
  end
end