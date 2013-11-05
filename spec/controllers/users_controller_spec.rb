require 'spec_helper'

describe UsersController do

  context "on success" do
    before(:each) do
      @user = mock_model(User,:save=>true)
      User.stub(:new) {@user}
      post :create, :user => {}
    end

    it "redirects" do
      response.should redirect_to(root_url)
    end

    it "assigns" do
      assigns[:user].should == @user
    end
  end
  
  #Sidney Added
  context "on failure" do
    it "renders 'new'" do
      @user = mock_model(User,:save=>false)
      User.stub(:new) {@user}
      post :create, :user => {}
      response.should render_template "users/new"
    end
  end

  context " on success edit" do
	  it "updates @user" do
		  user = User.update(attr_accessible)
		  get :update
	  end
  end
  
  context "with invalid information" do
		it "renders 'edit'" do
			@user = mock_model(User, :save=>false)
			User.stub(:edit) {@user}
			post :update, :user => {}
			response.should render_template "users/edit"
		end
  end	
end
