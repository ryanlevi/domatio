class Discussion < ActiveRecord::Base
  attr_accessible :title, :body, :userId

  # a discussion has many [discussion_messages]
  has_many :discussion_messages

  validates_presence_of :userId
  validates_presence_of :title

end
