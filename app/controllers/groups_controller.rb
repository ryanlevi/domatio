class GroupsController < ApplicationController

  def new
    if current_user
      @group = Groups.new
      if current_group
        redirect_to '/groups/index'
      end
    else
      redirect_to root_url, :notice => "You need to be logged in to do this."
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
    if current_user
      @friend = User.new
      if current_group
        @group_members = []
        User.all.each do |user|
          if user.groupid == current_group.groupid
            @group_members.push(user)
          end
        end
      else
        redirect_to '/groups/new', :notice => "You need a group to do that!"
      end
    else
      redirect_to root_url, :notice => "You need to be logged in to do this."
    end
  end

  def add_user_create
    email=params[:user][:email].downcase
    roommate=User.find_by_email(email)
    if(roommate)
      if(roommate.groupid)
        if(roommate.groupid==current_user.groupid)
          redirect_to "/groups/add_user" , :notice => "This person is already part of your group!"
        else
          redirect_to "/groups/add_user" , :notice => "That person is already in a group!  They must leave before they can join your group."
        end  
      else
        roommate.groupid = current_group.groupid
        roommate.save!
        redirect_to "/groups/add_user", :notice => "#{roommate.name} was added to your group!"
      end
    else
      if email =~ /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/
        new_user=User.new()
        new_user.groupid=current_group.groupid
        new_user.email=email
        new_user.save(:validate => false)
        UserMailer.group_and_site_invite(email, current_user, current_group).deliver
        redirect_to "/groups/add_user", :notice => "An invitation was sent to #{email}!"
      else
        redirect_to "/groups/add_user", :notice => "Invalid email!"
      end
    end
  end

  def index
    if current_user
      if current_group
        @group_members = []
        User.all.each do |user|
          if user.groupid == current_group.groupid
            @group_members.push(user)
          end
        end
        if @group_members.length <= 1
          redirect_to '/groups/add_user'
        end
      else
        redirect_to '/groups/new', :notice => "You need a group to do that!"
      end
    else
      redirect_to root_url, :notice => "You need to be logged in to do this."
    end
  end

  def leave
    if current_user
      if current_group
        tempGroup = current_group
        tempGroupName = current_group.groupname
        current_user.groupid = nil
        current_user.save!
        if User.find_by_groupid(tempGroup.groupid) == nil
          tempGroup.destroy
        end
        redirect_to '/groups/new', :notice => "You have left the group #{tempGroupName}."
      else
        redirect_to '/groups/new', :notice => "You need to be part of a group to do this."
      end
    else
      redirect_to root_url, :notice => "You need to be logged in to do this."
    end
  end

  def edit
    if current_group
      @group = Groups.find(params[:id])
    else
      redirect_to '/groups/new', :notice => "You need to be part of a group to do this."
    end
  end

  def update
    @group = Groups.find(params[:id])
    oldname = @group.groupname
    @group.groupname = params[:groups][:groupname]
    if @group.save
      redirect_to '/groups', :notice => "Group name changed from #{oldname} to #{@group.groupname}!"
    else
      render "edit"
    end
  end

end