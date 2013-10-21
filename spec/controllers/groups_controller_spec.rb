require 'spec_helper'

describe GroupsController do

  context "on success" do
    it "assigns @groups" do
      group = Groups.create(:groupname=>"hello")
      get :create
    end
  end

  context "on failure" do
    it "renders 'new'" do
      @group = mock_model(Groups,:save=>false)
      Groups.stub(:new) {@group}
      post :create, :groups => {}
      response.should render_template "groups/new"
    end
  end

end
