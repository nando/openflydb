class ApplicationController < ActionController::Base
  skip_before_filter :verify_authenticity_token
  
  private
    def require_admin
      redirect_to("/404.html") unless public_index? or admin?
    end

    def public_index?
      params[:action] == 'index' and %w{json pdf}.include?(params[:format])
    end

    def current_user
      @current_user ||= if session[:user_id]
                          Pilot.find_by_id session[:user_id]
                        elsif params[:admin] and admin = Pilot.find_with_password(params[:admin])
                          session[:user_id] = admin.id
                          admin
                        end
    end

    def admin?
      current_user && current_user.admin?
    end
end
