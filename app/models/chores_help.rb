class ChoresHelp < ActiveRecord::Base
  attr_accessible :chore_id, :user_id
  belongs_to :chores
  validates :user_id, :presence => true
end
