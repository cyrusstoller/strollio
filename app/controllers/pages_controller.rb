require 'httparty'

class PagesController < ApplicationController
  def welcome
    @profiles = get_profiles
        
    @query = HTTParty.get("http://where.yahooapis.com/geocode?q=" + URI.escape(params[:q]) + "&appid=" + ENV["YAHOO_APP_ID"]) if params[:q]
  end

  def about
  end
  
  def settings
  end
  
  private
  
  def get_profiles
    access_token = session[:access_token]
    url = APP_CONFIG["singly_api_base"] + "/profiles"
    HTTParty.get(url, :query => { :access_token => access_token }).parsed_response if access_token
  end
end
