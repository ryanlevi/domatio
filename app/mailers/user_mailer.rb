class UserMailer < ActionMailer::Base
  default from: "domatio.app@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Password Reset"
  end

  def welcome_email(user)
    @user = user
    mail :to => user.email, :subject => "Welcome to Domatio!", :body => "Congratulations, #{@user.name}, you've successfully registered at Domatio."
  end

  def group_and_site_invite(email, current_user, current_group)
    @current_user = current_user
    @current_group = current_group
    mail :to => email, :subject => "You'be been invited by #{@current_user.name} to join Domatio!"
  end

  def contact(email, subject, message)
    mail :to => 'domatio.app@gmail.com', :subject => subject, :body => "From:\n #{email}\n\n Body:\n  #{message}"
  end
end
