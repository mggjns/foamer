class HomeController < ApplicationController
  require 'google/api_client'
  require 'client_builder'

  def index

    if (user_signed_in? )
      # TODO: Is this the best way to check if we have the lat_lng cookie set?
      if (cookies[:lat_lng])
        @lat_lng = cookies[:lat_lng].split("|")
      end
      # Only query Google Calendar API if we don't have any events in the DB
      if current_user.events.where("start >= ?", Date.today).size == 0
        # Find me in application_controller.rb (as a helper method)
        google_query
      end
      # Fetch today's events from the DB to display in view
      @events = current_user.events.where("start >= ?", Date.today)
      @places = current_user.places
    end
  end

  def refresh
    current_user.events.destroy_all
    redirect_to root_url, :notice => 'Events refreshed from Google Calendar!'
  end

end



