class GroupsController < ApplicationController

  def new
    @group = Groups.new
    if current_group
      redirect_to '/groups/add_user'
    end
  end

  def create
    @group = Groups.new(params[:groups])  #creates a group object with the values in params derived from the form located in new.html.erb for groups
    if @group.save  #checks if the group object is save-able, if it is, enter the if-statement.
      current_user.groupid=@group.groupid  #essentially puts the user who created the group, into the group.
      current_user.save!
      redirect_to root_url, :notice => "You've created the group: #{@group.groupname}! Try inviting some friends!"
    else
      render "new"  #if the group was not save-able, we re-load groups/new
    end
  end

  def add_user
    @friend = User.new
  end

  def add_user_create
    email=params[:user][:email]
    roommate=User.find_by_email(email)
    if(roommate)
      if(roommate.groupid)
        redirect_to "/groups/add_user" , :notice => "That person is already in a group!  They must leave before they can join your group."
      else
        roommate.groupid = current_group.groupid
        roommate.save!
        redirect_to "/groups/add_user", :notice => "#{roommate.name} was added to your group!"
      end
    else
      if email =~ /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/
        UserMailer.group_and_site_invite(email, current_user).deliver
        redirect_to "/groups/add_user", :notice => "An invitation was sent to #{email}!"
      else
        redirect_to "/groups/add_user", :notice => "Invalid email!"
      end
    end
  end

end