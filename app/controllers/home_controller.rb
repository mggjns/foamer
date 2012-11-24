class HomeController < ApplicationController
  require 'google/api_client'
  require 'client_builder'

  def index

    if (user_signed_in? )
      # Only query Google Calendar API if we don't have any events in the DB
      if current_user.events.where("start >= ?", Date.today).size == 0
        # Find me in home_helper.rb
        google_query
      end
      # Fetch today's events from the DB to display in view
      @events = current_user.events.where("start >= ?", Date.today)
    end
  end

  def refresh
    # TODO: Make this destroy events for the current_user, then run index again
    current_user.events.destroy_all
  end

end

