class DiscussionController < ApplicationController
  def new
    @discussion = Discussion.new

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
    @discussion = Discussion.all
  end
end
