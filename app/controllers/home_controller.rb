# TODO: Can we cache the API query to Google somehow, so to speed things up?
class HomeController < ApplicationController
  require 'google/api_client'
  require 'client_builder'

  def index

    if (user_signed_in? )
      # Only query Google Calendar API if we don't have any events in the DB
      if current_user.events.where("start >= ?", Date.today).size == 0
        google_query
      end
      # Fetch today's events from the DB to display in view
      @events = current_user.events.where("start >= ?", Date.today)
    end
  end
end

