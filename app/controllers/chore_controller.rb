class ChoreController < ApplicationController

  def index
    if current_user
      if current_group
        @chores=[]
        destroyAuthorized=0
        Chore.where("groupid = '#{current_group.groupid}'").each do |chore|
          if(chore.time< Date.today)
            #for recurrence 1=weekly, 2=monthly, 3=bimonthly, 4=once
            case chore.recurrence
            when 1
              chore.time=chore.time+(7*24*60*60)
            when 2
              if chore.time.month == 12
                next_month = 1
                next_year = chore.time.year + 1
              else
                next_month = chore.time.month + 1
                next_year = chore.time.year
              end

              # DATE OF MONTH
              if chore.time.day == 30 or chore.time.day == 31
                case next_month
                when 2 # february
                  next_day = 28
                  next_day = 29 if Date.leap? chore.time.year
                when 4, 6, 9, 11 # april, june, sept, nov
                  next_day = 30
                else
                  next_day = chore.time.day
                end
              elsif chore.time.day == 29 and next_month == 2
                next_day = 28
                next_day = 29 if Date.leap? chore.time.year
              else
                next_day = chore.time.day
              end
              chore.time=Date.new(next_year, next_month, next_day)
              #END OF MONTHLY
            when 3
              chore.time=chore.time+(2*7*24*60*60)
            when 4
              ChoresHelp.where("chore_id = '#{chore.id}'").each do |choresHelper|
                choresHelper.destroy
              end
              destroyAuthorized=1
            else
              #something went wrong!  Reccurence is a value that was never intended!
              #:notice => "Reccurence Error"
            end
          end
          if(destroyAuthorized==1)
            chore.destroy
          else
            @chores.push chore
          end
        end
        @choresHelpers=[];
        @chores.each do |chore|
          specificHelper=[];
          ChoresHelp.where("chore_id = '#{chore.id}'").each do |choresHelper|
            specificHelper.push choresHelper
          end
          @choresHelpers.push specificHelper
        end
      else
        redirect_to root_url, :notice => "You need to be part of a group to do this."
      end
    else
      redirect_to root_url, :notice => "You need to be logged in to do this."
    end
  end

  def new
  	if current_user
  		if current_group
  			@chore=Chore.new
        @chores_help=ChoresHelp.new
        @chore.recurrence=1
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
  	if @chore.save
      if (params[:chores_help] != nil)
  		  helper_hash = {}
        params[:chores_help].each do |user, userid|
          helper_hash[:chore_id] = @chore.id
          helper_hash[:user_id] = userid.to_i
          @helper = ChoresHelp.create(helper_hash)
          @helper.save
        end
      end
      redirect_to '/chore', :notice => "You've created the chore: #{@chore.name}"
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

  def edit
    @current_chore=Chore.find(params[:id])
    if @current_chore != nil # you can edit a chore if it exists
      @chore=@current_chore
      @chores_help=ChoresHelp.new
      @users=[]
      User.where("groupid='#{current_user.groupid}'").each do |user|
        if user.name
          @users.push user
        end
      end
    end
  end

  def update
    @chore=Chore.find(params[:id].to_i)
    tempTime=@chore.time
    @chore.name=params[:chore][:name]
    @chore.recurrence=params[:chore][:recurrence]
    # we destroy all the associated ChoreHelp
    ChoresHelp.where("chore_id = '#{@chore.id}'").each do |choresHelper|
      choresHelper.destroy
    end
    if params[:chore][:time]=="" # if the time was not altered by the user.
      @chore.time=tempTime
    else
      @chore.time=params[:chore][:time]
    end
    if @chore.save
      if (params[:chores_help] != nil)
        helper_hash = {}
        # we create the new associated ChoreHelps
        params[:chores_help].each do |user, userid|
          helper_hash[:chore_id] = @chore.id
          helper_hash[:user_id] = userid.to_i
          @helper = ChoresHelp.create(helper_hash)
          @helper.save
        end
      end
      redirect_to '/chore/', :notice => "You've updated the chore: #{@chore.name}"
    else
      @users=[]
      User.where("groupid='#{current_user.groupid}'").each do |user|
        if user.name
          @users.push user
        end
      end
      render "edit"
    end
  end

  def destroy
    @chore = Chore.find(params[:id])
    name = @chore.name
    ChoresHelp.where("chore_id = '#{@chore.id}'").each do |choresHelper|
      choresHelper.destroy
    end   
    @chore.destroy
    redirect_to '/chore/', :notice => "You have permanently deleted the chore #{name}."
  end
  
end