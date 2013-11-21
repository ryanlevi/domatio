class SessionsController < ApplicationController
  def new
    # If the user is logged in, don't show them the log in page!!
    if current_user
      redirect_to '/groups/new'
    end
  end

  def create
    # The following line finds the user in our db by using their email
    user = User.find_by_email(params[:email].to_s.downcase)
    # If the password is correct...
    if user && user.name && user.authenticate(params[:password])
      if params[:remember_me]
        # and they check the remember me box, save permanent cookies
        cookies.permanent[:auth_token] = user.auth_token
      else
        # If they don't check remember me, just give a shorter length cookie
        cookies[:auth_token] = user.auth_token
      end
      if(user.groupid)
        User.where("groupid='#{user.groupid}'").each do |oldUser|
          unless oldUser.name
            if oldUser.created_at>(Time.now-(7*24*60*60))
              oldUser.destroy
            end
          end
        end
      end
      # Either way, after they login, redirect home and show them the login message
      redirect_to root_url, :notice => "Logged in!"
    else
      # If the password is wrong (or email isn't found), show them the message below:
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    # This is logout! It deletes our cookies from their browser and shows them a message
    cookies.delete(:auth_token)
    redirect_to root_url, :notice => "Logged out!"
  end
end