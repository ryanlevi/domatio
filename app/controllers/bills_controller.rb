class BillsController < ApplicationController
  def index
    # This statement makes sure the user is logged in and part of a group
    if current_user 
      if current_group
        Bill.where("groupid = '#{current_group.groupid}'").each do |bill|
          # finds all recurring bills that are marked as paid
          if bill.duedate <= Date.today
            bill.pending = 0
            bill.save
          end
          if bill.recurring
          end
        end
        @your_bill_list = [] # for a list of bills current user owns
        @your_bill_list_of_hashes = {} # for a hash that stores bills, users and amounts they each do
        @their_bill_list = [] #for a list of bills current user doesn't own
        @their_bill_list_of_hashes = {} # for a hash that stores bills, users and amounts they each do
        Bill.where("groupid = '#{current_group.groupid}'").each do |bill|
          if bill.pending == 1
            if bill.owner == current_user.email
              # If you own the bill, the bill is added to the following array
              @your_bill_list.push(bill)
            else
              # If you don't own the bill, but someone else in your group does, it's added to this array
              @their_bill_list.push(bill)
            end
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
        redirect_to root_url, :notice => "You need to be part of a group to access bills."
      end
    else
      redirect_to root_url, :notice => "You need to be logged in and part of a group to access bills."
    end
  end

  def past_bills
    @your_past_bills = []
    @their_past_bills = []
    @their_past_bill_list_of_hashes = {}
    @your_past_bill_list_of_hashes = {}
    Bill.where("groupid = '#{current_group.groupid}'").each do |bill|
      if bill.pending == 0
        if bill.owner == current_user.email
          @your_past_bills.push bill
        else
          @their_past_bills.push bill
        end
      end
    end
    @their_past_bills.each do |bill|
      instance_variable_set "@bill_#{bill.id}", Hash.new
      BillsHelp.where("bill_id = '#{bill.id}'").each do |bill_help|
        instance_variable_get("@bill_#{bill.id}")[bill_help.user] = bill_help.amount
        @their_past_bill_list_of_hashes[bill.id] = instance_variable_get("@bill_#{bill.id}")
      end
    end
    @your_past_bills.each do |bill|
      instance_variable_set "@bill_#{bill.id}", Hash.new
      BillsHelp.where("bill_id = '#{bill.id}'").each do |bill_help|
        instance_variable_get("@bill_#{bill.id}")[bill_help.user] = bill_help.amount
        @your_past_bill_list_of_hashes[bill.id] = instance_variable_get("@bill_#{bill.id}")
      end
    end
    if @your_past_bills.length + @their_past_bills.length <= 0
      redirect_to '/bills', :notice => "You don't have any past bills!"
    end
  end

  def new
    if current_user and current_group
      @bill = Bill.new
      @bills_help = BillsHelp.new
      @users = []
      User.all.each do |user|
        if user.groupid == current_group.groupid and user.name # this will take out pending users
          @users.push user
        end
      end
    else
      redirect_to root_url, :notice => "You need to be logged in and part of a group to access bills."
    end
  end

  def stash
    @bill = Bill.find(params[:id])
    name = @bill.name
    @bill.pending = 0
    @bill.save
    # The following line finds all the rows in BillsHelp that have the same Bill ID as the one being marked paid
    # and then marks each of them paid
    BillsHelp.where("bill_id = '#{params[:id]}'").each {|bill_in_bh_table| bill_in_bh_table.pending = 0}
    redirect_to '/bills', :notice => "You have deleted the bill #{name}."
  end

  def unstash
    @bill = Bill.find(params[:id])
    name = @bill.name
    if @bill.duedate.to_date <= Date.today # if duedate passed, reload page
      redirect_to '/bills/past_bills', :notice => "Due date passed. Can't undo #{name}."
    else
      @bill.pending = 1
      @bill.save
      # The following line finds all the rows in BillsHelp that have the same Bill ID as the one being marked pending
      # and then marks each of them pending
      BillsHelp.where("bill_id = '#{params[:id]}'").each {|bill_in_bh_table| bill_in_bh_table.pending = 1}
      redirect_to '/bills', :notice => "The bill #{name} has been reactivated."
    end
  end

  def destroy
    @bill = Bill.find(params[:id])
    name = @bill.name
    @bill.destroy
    # The following line finds all the rows in BillsHelp that have the same Bill ID as the one being deleted
    # and then destroys each of them
    BillsHelp.where("bill_id = '#{params[:id]}'").each {|bill_in_bh_table| bill_in_bh_table.destroy}
    redirect_to '/bills/past_bills', :notice => "You have permanently deleted the bill #{name}."
  end

  def create
    # add a row to the Bills table with the supplied Bill Name, Amount Due and Due Date
    @bill = Bill.new(params[:bill])
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