class UsersController < ApplicationController
  def new
    # The folling line creates a class variable so that the view can reference the User model
    @user = User.new
    if current_user
      # if the user is logged in, redirect them to the "new group" page; if not, display the form
      redirect_to '/groups/new'
    end
  end

  def create
    invited_user=User.find_by_email(params[:user][:email])
    if invited_user
      @user=invited_user
      @user.name=params[:user][:name]
      @user.password=params[:user][:password]
      @user.password_confirmation=params[:user][:password_confirmation]
    else
      # Creates a new user with the params from the form
      @user = User.new(params[:user])
    end
    
    # The following if statement checks for form validations (like passwords matching and valid email)
    if @user.save
      # If everything is ok, it sends them an email, assigns cookies and redirects them to the log in with a Welcome message
      UserMailer.welcome_email(@user).deliver
      cookies[:auth_token] = @user.auth_token
      redirect_to root_url, :notice => "Signed Up! Welcome to Domatio #{@user.name}!"
    else
      # If there are validation errors, it reloads the form with the errors.
      render "new"
    end
  end

  def index
  end
end
