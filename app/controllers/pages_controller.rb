require 'httparty'

class PagesController < ApplicationController
  def welcome
    @profiles = get_profiles
  end

  def about
  end
  
  def settings
  end
  
  private
  
  def get_profiles
    url = APP_CONFIG["singly_api_base"] + "/profiles"
    HTTParty.get(url, :query => { :access_token => session[:access_token] }).parsed_response
  end
end
