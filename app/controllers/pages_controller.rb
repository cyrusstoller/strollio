require 'httparty'

class PagesController < ApplicationController
  def welcome
    @profiles = get_profiles
  end

  def about
    @title = "About"
  end
  
  def pictures
    if session[:access_token].nil?
      flash[:error] = "Oops. You need to sign into a social network first!"
      redirect_to root_path
      return
    end
      
    if params[:q]
      lat_lon_url = "http://where.yahooapis.com/geocode?q=" + URI.escape(params[:q]) + "&appid=" + ENV["YAHOO_APP_ID"]
      @query = HTTParty.get(lat_lon_url).parsed_response
      unless @query["ResultSet"]["Result"].kind_of?(Array)
        begin
          @lat = @query["ResultSet"]["Result"]["latitude"]
          @lon = @query["ResultSet"]["Result"]["longitude"]
        rescue
          flash[:error] = "We're pretty sure that \"#{params[:q]}\" is not a real place."
          redirect_to root_path
          return
        end
        
        @pictures = get_pictures_in
        @additional_pictures = get_additional_pictures(@pictures.count) rescue nil
      end
    else
      flash[:error] = "Oops. You forgot to tell us what to search for."
      redirect_to root_path
      return
    end
    
    if @pictures.blank? and @additional_pictures.blank? and not @query["ResultSet"]["Result"].kind_of?(Array)
      flash[:error] = "Uh oh there aren't any results for \"#{params[:q]}\"."
      redirect_to root_path
      return
    end
  end
  
  def random
    redirect_to pictures_path(:q => Random.rand(100000))
  end
  
  private
  
  def get_profiles
    access_token = session[:access_token]
    url = APP_CONFIG["singly_api_base"] + "/profiles"
    HTTParty.get(url, :query => { :access_token => access_token }).parsed_response if access_token
  end
  
  def get_pictures_in(radius = 10)
    access_token = session[:access_token]
    res = []
    url = APP_CONFIG["singly_api_base"] + "/v0/types/photos_feed"
    query = { :access_token => access_token, :min_count => 1000, :near => "#{@lat},#{@lon}", :dedup => true, :within => radius }
    res += HTTParty.get(url, :query => query ).parsed_response if access_token
    url = APP_CONFIG["singly_api_base"] + "/v0/types/photos"
    res += HTTParty.get(url, :query => query ).parsed_response if access_token
  end
  
  def get_additional_pictures(existing_pics = 0, radius = 10)
    r = radius * 1000
    access_token = session[:access_token]
    url = APP_CONFIG["singly_api_base"] + "/proxy/instagram/media/search"
    res = HTTParty.get(url, :query => { :access_token => access_token, :lat => @lat, :lng => @lon, :distance => r }).parsed_response if access_token
    return res["data"]
  end
end
