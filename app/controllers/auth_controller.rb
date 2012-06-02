class AuthController < ApplicationController
  def callback
    auth = request.env["omniauth.auth"]
    session[:access_token] = auth.credentials.token
    redirect_to root_path
  end

  def logout
    session.clear
    redirect_to root_path
  end

end
