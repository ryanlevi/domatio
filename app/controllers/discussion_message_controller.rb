class DiscussionMessageController < ApplicationController
  def new
    if current_user
      @discussion_id = params[:discussion_id]
      @discussion = Discussion.find(@discussion_id)
      if @discussion.user.groupid == current_user.groupid
        @discussion_message = DiscussionMessage.new()
      else
        redirect_to root_url, :notice => "You need to be logged in to do this."
      end
    else
      redirect_to root_url, :notice => "You need to be logged in to do this."
    end
  end

  def create
    @discussion_message = DiscussionMessage.new(params[:discussion_message])
    # The following if statement checks for form validations 
    if @discussion_message.save
      # associate datafields and save 
      @discussion_message.user = current_user
      @discussion_id = params[:discussion_id]
      @discussion = Discussion.find(@discussion_id)
      @discussion.increment(:messages_count, by = 1)
      @discussion_message.discussion = @discussion

      @discussion.save!
      @discussion_message.save!
      redirect_to "/discussion/#{@discussion.id}", :notice => "Reply created in Discussion: #{@discussion_message.discussion.title}!"
    else
      # If there are validation errors, it reloads the form with the errors.
      render "new"
    end
  end

  def create_inline
    # Creates a new discussion with the params from the inline form 
    @discussion_message = DiscussionMessage.new(params[:discussion_message])
    @discussion_id = params[:discussion_id]
    @discussion = Discussion.find(@discussion_id)
    # The following if statement checks for form validations (like passwords matching and valid email)
    if @discussion_message.save
      @discussion_message.user = current_user
      @discussion.increment(:messages_count, by = 1)
      @discussion_message.discussion = @discussion
      @discussion.save!
      @discussion_message.save!
      redirect_to "/discussion/#{@discussion.id}", :notice => "Reply created in Discussion: #{@discussion_message.discussion.title}!"
    else
      # If there are validation errors, it reloads the form with the errors.
      render :template => "discussion/show",  :params => { :discussion => @discussion }
    end
  end

  def destroy
    # simply distroy the reply 
    @discussion_message = DiscussionMessage.find(params[:id])
    @discussion = @discussion_message.discussion
    @discussion.messages_count = @discussion.messages_count - 1
    @discussion.save

    if current_user.id == @discussion_message.user.id
      @discussion_message.destroy
      redirect_to "/discussion/#{@discussion.id}", :notice => "Reply deleted successfully."
    else
      raise "user is not creator and must not delete message"
    end

  end

end
