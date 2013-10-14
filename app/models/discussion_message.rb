class DiscussionMessage < ActiveRecord::Base
  attr_accessible :title, :body, :discussionId, :userId
end
