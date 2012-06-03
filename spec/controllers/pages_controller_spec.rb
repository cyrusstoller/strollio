require 'spec_helper'

describe PagesController do
  render_views

  describe "GET 'welcome'" do
    it "returns http success" do
      stub_request(:get, "https://api.singly.com/profiles?access_token=").
               to_return(:status => 200, :body => "", :headers => {})
               
      get 'welcome'
      response.should be_success
    end
  end

  describe "GET 'about'" do
    it "returns http success" do
      get 'about'
      response.should be_success
    end
  end
  
  describe "GET 'pictures'" do
    it "returns http success" do
      session[:access_token] = "foo"
      get 'pictures'
      response.should redirect_to root_path
    end
  end

end
