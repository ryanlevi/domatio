class ChoresHelp < ActiveRecord::Base
  # Chores help is a database that stores chores assigned to each user in a group
  attr_accessible :chore_id, :user_id
  belongs_to :chores
  validates :user_id, :presence => true
end
