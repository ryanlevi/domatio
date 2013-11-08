class ChoreController < ApplicationController
  def index
  end

  def new
  	if current_user
  		if current_group
  			@chore=Chore.new
  		else
  			redirect_to root_url, :notice => "You need to be part of a group to do this."
  		end
  	else
  		redirect_to root_url, :notice => "You need to be logged in to do this."
  	end
  end

  def create
  	@chore=Chore.new(params[:chore])
  	if chore.save
  		#cool
  	else
  		render "new"
  	end

  end



end
