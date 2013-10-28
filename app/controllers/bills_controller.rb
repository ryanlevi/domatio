class BillsController < ApplicationController
  def index
    # This statement makes sure the user is logged in and part of a group
    if current_user and current_group
      @bill_list_yours = []
      @bill_list_mine = []
      @bill_costs = {}
      # Calculating the total number of users in the group
      @user_no = 0
      User.all.each do |user|
        if user.groupid == current_group.groupid
          @user_no += 1
        end
      end
      Bill.all.each do |bill|
        if bill.groupid == current_group.groupid
          if bill.owner == current_user.email
            # If you own the bill, the bill is added to the following array
            @bill_list_yours.push(bill)
          else
            # If you don't own the bill, but someone else in your group does, it's added to this array
            @bill_list_mine.push(bill)
          end
          # This creates a hash that stores all the bills in your group with their amounts
          @bill_costs[bill.name] = bill.price
        end
      end
      if @bill_list_yours.length + @bill_list_mine.length <= 0
        redirect_to '/bills/new', :notice => "You don't have any bills yet!"
      end
    else
      redirect_to root_url, :notice => "You need to be logged in and part of a group to access bills."
    end
  end

  def new
    @bill = Bill.new
    @users = []
    User.all.each do |user|
      if user.groupid == current_group.groupid
        @users.push user
      end
    end
  end

  def destroy
    @bill = Bill.find(params[:id])
    name = @bill.name
    @bill.destroy
    redirect_to '/bills', :notice => "You have deleted the bill #{name}."
  end

  def create
    @bill = Bill.new(params[:bill])
    @bill.owner = current_user.email
    @bill.groupid = current_user.groupid
    if @bill.save
      redirect_to '/bills', :notice => "You've created the bill: #{@bill.name}!"
    else
      render "new"
    end
  end
end
