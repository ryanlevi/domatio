require 'spec_helper'

describe ErrorsController do

  describe "GET 'e404'" do
    it "returns http success" do
      get 'e404'
      response.should be_success
    end
  end

  describe "GET 'e422'" do
    it "returns http success" do
      get 'e422'
      response.should be_success
    end
  end

  describe "GET 'e500'" do
    it "returns http success" do
      get 'e500'
      response.should be_success
    end
  end

end
