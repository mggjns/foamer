class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :user_signed_in?
  helper_method :correct_user?
  helper_method :start_home
  helper_method :current_location

  around_filter :user_time_zone, if: :current_user

  rescue_from ActiveRecord::RecordNotFound, :with => :wipe_session


  private
    def wipe_session
      reset_session
      render 'default'
    end

    def current_user
      # TODO: this breaks if we have a stale session (bad user_id stored in user's browser )
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    # def start_home
    #   @places.first.address
    # end

    def user_signed_in?
      return true if current_user
    end


    def correct_user?
      @user = User.find(params[:id])
      unless current_user == @user
        redirect_to root_url, :alert => "Access denied."
      end
    end

    def authenticate_user!
      if !current_user
        redirect_to default_url, :alert => 'You need to sign in for access to this page.'
      end
    end

    def user_time_zone(&block)
      Time.use_zone(current_user.timezone, &block)
    end
    
    def current_location
      @current_location = current_user.places.find_by_name("Current Location")   
    end
  protect_from_forgery
end
