class UserMailer < ActionMailer::Base
  default from: "domatio.app@gmail.com"

  # see views/user_mailer for email bodies when unspecified

  def password_reset(user)
    # sends an email to the user with the password reset token
    @user = user
    mail :to => user.email, :subject => "Password Reset"
  end

  def welcome_email(user)
    # sends an email to the user welcoming them to our website
    @user = user
    mail :to => user.email, :subject => "Welcome to Domatio!", :body => "Congratulations, #{@user.name}, you've successfully registered at Domatio."
  end

  def group_and_site_invite(email, current_user, current_group)
    # sends an email to the user when they've been invited to the website
    @current_user = current_user
    @current_group = current_group
    mail :to => email, :subject => "You'be been invited by #{@current_user.name} to join Domatio!"
  end

  def contact(email, subject, message)
    # this is for the contact page, so users can email us with their comments/suggestions
    mail :to => 'domatio.app@gmail.com', :subject => subject, :body => "From:\n #{email}\n\n Body:\n  #{message}"
  end
end
