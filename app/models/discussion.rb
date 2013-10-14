class Discussion < ActiveRecord::Base
  attr_accessible :title, :body, :userId
end
