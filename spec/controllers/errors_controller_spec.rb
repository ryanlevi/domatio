require 'spec_helper'

describe ErrorsController do

  describe "GET '404'" do
    it "returns http success" do
      get '404'
      response.should be_success
    end
  end

  describe "GET '422'" do
    it "returns http success" do
      get '422'
      response.should be_success
    end
  end

  describe "GET '500'" do
    it "returns http success" do
      get '500'
      response.should be_success
    end
  end

end
