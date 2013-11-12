class ChoreController < ApplicationController
  def index
  end

  def new
  	if current_user
  		if current_group
  			@chore=Chore.new
        @chores_help=ChoresHelp.new
        @users=[]
        User.where("groupid='#{current_user.groupid}'").each do |user|
          if user.name
            @users.push user
          end
        end
  		else
  			redirect_to root_url, :notice => "You need to be part of a group to do this."
  		end
  	else
  		redirect_to root_url, :notice => "You need to be logged in to do this."
  	end
  end

  def create
  	@chore=Chore.new(params[:chore])
    @chore.groupid=current_group.groupid
    @chore.time=Time.now  # THIS IS TEMPORARY FOR TESTING  THIS STILL NEEDS TO BE WORKED ON!!!!!!!!@#!@#!#
  	if @chore.save
  		helper_hash = {}
      params[:chores_help].each do |user, userid|
        helper_hash[:chore_id] = @chore.id
        helper_hash[:user_id] = userid.to_i
        @helper = ChoresHelp.create(helper_hash)
        @helper.save
      end
      redirect_to '/chore/new', :notice => "You've created the chore: #{@chore.name}"
  	else
      @users=[]
      User.where("groupid='#{current_user.groupid}'").each do |user|
        if user.name
          @users.push user
        end
      end
  		render "new"
  	end

  end



end
