class BillsController < ApplicationController
  def index
    # This statement makes sure the user is logged in and part of a group
    if current_user and current_group
      @your_bill_list = [] # for a list of bills current user owns
      @your_bill_list_of_hashes = {} # for a hash that stores bills, users and amounts they each do
      @their_bill_list = [] #for a list of bills current user doesn't own
      @their_bill_list_of_hashes = {} # for a hash that stores bills, users and amounts they each do
      @bill_costs = {}
      # Calculating the total number of users in the group
      @user_no = 0
      User.all.each do |user|
        if user.groupid == current_group.groupid and user.name # this will take out pending users
          @user_no += 1
        end
      end
      Bill.all.each do |bill|
        if bill.groupid == current_group.groupid
          if bill.owner == current_user.email
            # If you own the bill, the bill is added to the following array
            @your_bill_list.push(bill)
          else
            # If you don't own the bill, but someone else in your group does, it's added to this array
            @their_bill_list.push(bill)
          end
          # This creates a hash that stores all the bills in your group with their amounts
          @bill_costs[bill.name] = bill.price
        end
      end
      @their_bill_list.each do |bill|
        instance_variable_set "@bill_#{bill.id}", Hash.new
        BillsHelp.where("bill_id = '#{bill.id}'").each do |bill_help|
          instance_variable_get("@bill_#{bill.id}")[bill_help.user] = bill_help.amount
          @their_bill_list_of_hashes[bill.id] = instance_variable_get("@bill_#{bill.id}")
        end
      end
      @your_bill_list.each do |bill|
        instance_variable_set "@bill_#{bill.id}", Hash.new
        BillsHelp.where("bill_id = '#{bill.id}'").each do |bill_help|
          instance_variable_get("@bill_#{bill.id}")[bill_help.user] = bill_help.amount
          @your_bill_list_of_hashes[bill.id] = instance_variable_get("@bill_#{bill.id}")
        end
      end
      if @your_bill_list.length + @their_bill_list.length <= 0
        redirect_to '/bills/new', :notice => "You don't have any bills yet!"
      end
    else
      redirect_to root_url, :notice => "You need to be logged in and part of a group to access bills."
    end
  end

  def new
    @bill = Bill.new
    @bills_help = BillsHelp.new
    @users = []
    User.all.each do |user|
      if user.groupid == current_group.groupid and user.name # this will take out pending users
        @users.push user
      end
    end
  end

  def destroy
    @bill = Bill.find(params[:id])
    name = @bill.name
    @bill.destroy
    # The following line finds all the rows in BillsHelp that have the same Bill ID as the one being deleted
    # and then destroys each of them
    BillsHelp.where("bill_id = '#{params[:id]}'").each {|bill_in_bh_table| bill_in_bh_table.destroy}
    redirect_to '/bills', :notice => "You have deleted the bill #{name}."
  end

  def create
    # add a row to the Bills table with the supplied Bill Name, Amount Due and Due Date
    @bill = Bill.new(params[:bill])
    debugger
    # if the user checked recurring, store the value of the date of the month in the db
    # if not, leave it as nil in the db
    @bill.recurring = @bill.duedate.day if params[:recurring].to_i == 1
    # add the owner and groupid to the row in the table
    @bill.owner = current_user.email
    @bill.groupid = current_user.groupid
    if @bill.save # if no validation errors
      # the following looks at the fields in the form that pertain to individual user amounts due
      # it takes in the values you submitted and adds them row by row to the BillsHelp table
      helper_hash = {}
      params[:bills_help].each do |user, amount|
        helper_hash[:bill_id] = @bill.id
        helper_hash[:user] = user
        helper_hash[:amount] = amount
        @helper = BillsHelp.create(helper_hash)
      end
      redirect_to '/bills', :notice => "You've created the bill: #{@bill.name}!"
    else
      @users = []
      User.all.each do |user|
        if user.groupid == current_group.groupid and user.name # this will take out pending users
          @users.push user
        end
      end
      render "new"
    end
  end
end
