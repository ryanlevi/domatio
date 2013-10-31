class BillsHelp < ActiveRecord::Base
  attr_accessible :amount, :bill_id, :user
  belongs_to :bills
  validates :user, :presence => true
end
