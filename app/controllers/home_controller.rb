class HomeController < ApplicationController
  def index
    if current_user
      # if the user is logged in, redirect them to the "new group" page; if not, display the form
      redirect_to '/groups/new'
    end
  end

  def about
  end
end
