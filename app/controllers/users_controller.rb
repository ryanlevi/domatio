class UsersController < ApplicationController
  def new
    @user = User.new
    if current_user
      redirect_to '/groups/new'
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      UserMailer.welcome_email(@user).deliver
      cookies[:auth_token] = @user.auth_token
      redirect_to root_url, :notice => "Signed Up! Welcome to Domatio #{@user.name}!"
    else
      render "new"
    end
  end

  def index
  end
end
