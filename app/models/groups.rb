class Groups < ActiveRecord::Base
  attr_accessible :groupid, :groupname  #makes the attributes of class Groups called groupid and groupname accessable from elsewhere

  validates_uniqueness_of :groupid  #validates that groupid is unique NOTE: This could be removed.
  validates_presence_of :groupname  #Ensures that someone cannot name a group "" or empty string.

  before_create { generate_token(:groupid) }  #this will generate a unique groupid for a Group object before its creation

  #generate_token(column) will create a random token that is unique for the element type column
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

end
