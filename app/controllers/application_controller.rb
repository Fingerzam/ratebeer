class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :currently_signed_in?, :signed_in?
  
  def current_user
    return if User.count == 0
    return if session[:user_id].nil?
    User.find(session[:user_id])
  end

  def currently_signed_in?(user)
    current_user == user
  end

  def signed_in?
    not current_user.nil?
  end

  def ensure_that_signed_in
    redirect_to signin_path, :notice => 'you should be signed in' if current_user.nil?
  end

  def admin?
    redirect_to :back, :notice => 'you are not an admin' unless current_user.admin
  end
end
