class HomeController < ApplicationController
  def index
    if current_user
      # if the user is logged in, redirect them to the "new group" page; if not, display the form
      redirect_to '/groups/new'
    end
  end

  # The following methods are empty because they associated pages are virtually static.

  def about
  end

  def contact
  end

  def faq
  end

  def contact_post
    UserMailer.contact(params[:email], params[:subject], params[:message]).deliver
    redirect_to root_url, :notice => "Thanks for your feedback!"
  end
end
