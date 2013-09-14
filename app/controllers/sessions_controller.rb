class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.where(username: params[:username]).first
    if user.nil? or not user.authenticate params[:password] then
      redirect_to :back, notice: "username and password do not match"
    else
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Welcome back!"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end
end
