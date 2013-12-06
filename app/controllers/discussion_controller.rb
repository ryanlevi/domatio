class DiscussionController < ApplicationController
  def new
    if current_user
      @discussion = Discussion.new
    else
      redirect_to root_url, :notice => "You need to be logged in to do this."
    end
  end

  def create
    @discussion = Discussion.new(params[:discussion])
    # The following if statement checks for form validations 
    if @discussion.save
      @discussion.user = current_user
      @discussion.save!
      redirect_to "/discussion/#{@discussion.id}", :notice => "Discussion #{@discussion.title} created!"
    else
      # If there are validation errors, it reloads the form with the errors.
      render "new"
    end
  end

  def list
    if current_user
      if current_group
        # find all discussion associated to the user
        @discussion = Discussion.joins(:user).where(:users => {:groupid => current_user.groupid})
      else
        redirect_to root_url, :notice => "You need to be part of a group to access discussions."
      end
    else
      redirect_to root_url, :notice => "You need to be logged in to do this."
    end
  end

  def show
    if current_user
      @discussion = Discussion.find(params[:id])
      if @discussion.user.groupid == current_user.groupid
        @discussion_message = DiscussionMessage.new()
      else
        redirect_to root_url, :notice => "You need to be logged in to do this."
      end
    else
      redirect_to root_url, :notice => "You need to be logged in to do this."
    end
  end

  def destroy
    @discussion = Discussion.find(params[:id])
    if current_user.id == @discussion.user_id
      # destroy discussion as well as all associated replies
      @discussion.destroy
      DiscussionMessage.where("discussion_id = '#{params[:id]}'").destroy_all
      redirect_to '/discussion', :notice => "Discussion succesfully deleted."
    else
      raise "user is not creator and must not delete discussion"
    end
  end
end
