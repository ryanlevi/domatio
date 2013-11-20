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
    invited_user=User.find_by_email(params[:user][:email].to_s.downcase)
    if invited_user && invited_user.name == nil
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
  
  def edit 
    if current_user
      @user = current_user
    end
  end
  
  def update
    @user = current_user
    #Update attributes with values from form 
    @user.name=params[:user][:name]
    @user.email=params[:user][:email]
    if params[:user][:password] != nil
      @user.password=params[:user][:password]
      @user.password_confirmation=params[:user][:password_confirmation]
    end    
    #If the updates to user are valid, then save the user 
    if @user.save
        flash[:notice]='Your account has been successfully updated!'
      redirect_to '#'
    else
      # flash[:error]=@user.errors.full_messages
      render 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    name = @user.name
    if @user == current_user
      notice = "Your account has been deleted! Sorry to see you go!"
      cookies.delete(:auth_token)
    else
      notice = "#{@user.email} has been removed!"
    end
    Bills.where(:owner => @user.id).each { |bill| bill.destroy }
    BillsHelp.where(:user => @user.id).each { |bill| bill.destroy }
    ChoreHelp.where(:user_id => @user.id).each { |chore| chore.destroy }
    Discussion.where(:user_id => @user.id).each { |discussion| discussion.destroy }
    DiscussionMessage.where(:user_id => @user.id).each { |discussion| discussion.destroy }

    @user.destroy
    redirect_to root_url, :notice => notice
  end
  
  def index
  end
  
end
