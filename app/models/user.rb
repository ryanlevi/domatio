class User < ActiveRecord::Base
  # setters, getters
  attr_accessible :email, :groupid, :name, :password, :password_confirmation, :created_at
  has_many :bills, dependent: :destroy
  
  # user can create [discussion] and [discussionMessages]
  has_many :discussion_messages
  has_many :discussion

  has_secure_password

  validates_uniqueness_of :email # makes sure email is not already taken
  validates_presence_of :email # makes sure user typed in an email
  validates :email, :email => true
  validates_presence_of :password, :on => :create # makes sure user typed in a password

  before_create { generate_token(:auth_token) }
  validates :email, :presence => true

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
  
  before_save do
    self.email.downcase! if self.email
  end
  
end
