class SessionsController < ApplicationController

  # TODO: Edit so that controller logs a user in or signs them up, depending on the case.
  
  def new
    redirect_to '/auth/google_oauth2'
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.where(:provider => auth['provider'],
                      :uid => auth['uid']).first || User.create_with_omniauth(auth)
    user.token = auth[:credentials][:token];
    user.token_expires_at = Time.at(auth[:credentials][:expires_at])
    user.refresh_token = auth[:credentials][:refresh_token]
    # binding.pry
    # user.timezone = auth[:profile][:timezone]
    user.save

    session[:user_id] = user.id
    if current_user.calendars.size == 0
      redirect_to welcome_url, :notice => 'Signed in!'
    else
      redirect_to home_url, :notice => 'Signed in!'
    end
    
  end

  def destroy
    reset_session
    redirect_to root_url, :notice => 'Signed out!'
  end

  def failure
    # if you want to debug something better, this is the object you want
    #auth = request.env["omniauth.error"]
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end

end
