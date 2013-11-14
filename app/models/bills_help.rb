class BillsHelp < ActiveRecord::Base
  attr_accessible :amount, :bill_id, :user, :pending
  belongs_to :bills
  validates :user, :presence => true
end
