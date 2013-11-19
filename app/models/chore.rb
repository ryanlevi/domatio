class Chore < ActiveRecord::Base
  attr_accessible :groupid, :name, :recurrence, :time

  #for recurrence 1=weekly, 2=monthly, 3=bimonthly, 4=once

  has_many :chores_help, dependent: :destroy
  validates_presence_of :time
  validates_presence_of :name
  
end
