class DiscussionMessageController < ApplicationController
  def new
    @discussion_message = DiscussionMessage.new

  end

  def create
    # Creates a new user with the params from the form
    @discussion_message = DiscussionMessage.new(params[:discussion_message])
    # The following if statement checks for form validations (like passwords matching and valid email)
    if @discussion_message.save
      @discussion_message.user = current_user
      @discussion_message.save!
      redirect_to root_url, :notice => "Reply #{@discussion_message.title} created in Discussion: #{@discussion_message.discussion.title}!"
    else
      # If there are validation errors, it reloads the form with the errors.
      render "new"
    end
  end

  def list
    @discussion_message = DiscussionMessage.all
  end
end
