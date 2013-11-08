class Chore < ActiveRecord::Base
  attr_accessible :groupid, :name, :recurrence, :time

  validates_presence of :time
  validates_presence of :name
  
end
