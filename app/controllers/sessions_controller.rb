class SessionsController < ApplicationController
  def new
    session[:user_id] = nil
  end

  def create
    if user = Pilot.authenticate(params[:email], params[:password]) and
      session[:user_id] = user.id
      redirect_to competitions_path
    else
      redirect_to :action => 'new'
    end
  end
end
