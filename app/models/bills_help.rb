class BillsHelp < ActiveRecord::Base
  # Bills Help is a database that stores Bill amounts for each user in a group
  attr_accessible :amount, :bill_id, :user, :pending
  belongs_to :bill
  validates :user, :presence => true
end
