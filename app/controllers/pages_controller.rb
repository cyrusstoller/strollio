require 'httparty'

class PagesController < ApplicationController
  def welcome
    @profiles = get_profiles
  end

  def about
  end
  
  def settings
  end
  
  def pictures
    if params[:q]
      lat_lon_url = "http://where.yahooapis.com/geocode?q=" + URI.escape(params[:q]) + "&appid=" + ENV["YAHOO_APP_ID"]
      @query = HTTParty.get(lat_lon_url).parsed_response
      unless @query["ResultSet"]["Result"].kind_of?(Array)
        @lat = @query["ResultSet"]["Result"]["latitude"]
        @lon = @query["ResultSet"]["Result"]["longitude"]
      end
    end
    
  end
  
  private
  
  def get_profiles
    access_token = session[:access_token]
    url = APP_CONFIG["singly_api_base"] + "/profiles"
    HTTParty.get(url, :query => { :access_token => access_token }).parsed_response if access_token
  end
end
