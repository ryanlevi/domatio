class DiscussionMessage < ActiveRecord::Base
  attr_accessible :content

  # a message belongs to a [discussion] and has a [user]
  belongs_to :discussion
  belongs_to :user

  validates_presence_of :content


end
