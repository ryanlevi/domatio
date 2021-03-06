class Discussion < ActiveRecord::Base
  attr_accessible :title, :body, :user, :messages_count

  # a discussion has many [discussion_messages] and was created by a [user]
  has_many :discussion_messages
  belongs_to :user

  validates_presence_of :title

end
