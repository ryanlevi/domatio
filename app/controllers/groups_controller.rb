class GroupsController < ApplicationController

  def new
    @group = Groups.new
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
end