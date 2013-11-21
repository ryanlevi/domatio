class BillsHelp < ActiveRecord::Base
  attr_accessible :amount, :bill_id, :user, :pending
  belongs_to :bill
  validates :user, :presence => true
end
