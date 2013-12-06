class ApplicationController < ActionController::Base
  protect_from_forgery

  private
  # The following functions create variables that can be accessed in ALL controllers and views

    # uses cookies to determine the current user
    def current_user
      @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
    end

    # determines user's group by reading db
    def current_group
      @current_group ||= Groups.find_by_groupid!(current_user.groupid) if current_user.groupid
    end

  # the following line makes the above methods available to every controller that inherits from this class
  helper_method :current_user, :current_group
end
