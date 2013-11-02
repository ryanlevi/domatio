class DiscussionController < ApplicationController
  def new
    if current_user
      @discussion = Discussion.new
    else
      redirect_to root_url, :notice => "You need to be logged in to do this."
    end
  end

  def create
    # Creates a new user with the params from the form
    @discussion = Discussion.new(params[:discussion])
    # The following if statement checks for form validations (like passwords matching and valid email)
    if @discussion.save
      @discussion.user = current_user
      @discussion.save!
      redirect_to root_url, :notice => "Discussion #{@discussion.title} created!"
    else
      # If there are validation errors, it reloads the form with the errors.
      render "new"
    end
  end

  def list
    if current_user
      @discussion = Discussion.joins(:user).where(:users => {:groupid => current_user.groupid})
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
end
