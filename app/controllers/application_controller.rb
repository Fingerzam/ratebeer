class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user
  
  def current_user
    return if session[:user_id].nil?
    User.find(session[:user_id])
  end
end
