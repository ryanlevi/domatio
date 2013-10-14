class DiscussionMessage < ActiveRecord::Base
  attr_accessible :title, :body

  # a message belongs to a [discussion] and has a [user]
  belongs_to :discussion
  has_one :user

  validates_presence_of :title
  validates_presence_of :body


end
