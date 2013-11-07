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
  
end
