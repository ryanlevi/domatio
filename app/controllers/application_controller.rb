class ApplicationController < ActionController::Base
  protect_from_forgery


  private

def current_user
  @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
end

# current_group creates a var that is set to the group of the current_user
def current_group
  @current_group ||= Groups.find_by_groupid!(current_user.groupid) if current_user.groupid
end

  helper_method :current_user, :current_group
end
