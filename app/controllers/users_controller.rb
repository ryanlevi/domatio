class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      debugger
      UserMailer.welcome_email(@user).deliver
      redirect_to root_url, :notice => "Signed Up!"
    else
      render "new"
    end
  end

  def index
  end
end
