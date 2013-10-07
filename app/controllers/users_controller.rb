class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      ActionMailer::Base.mail(:from => "info@domatio.com", :to => User.email, :subject => "Welcome to Domatio!", :body => "Congratulations, you've successfully registered at Domatio.").deliver
      redirect_to root_url, :notice => "Signed Up!"
    else
      render "new"
    end
  end

  def index
  end
end
