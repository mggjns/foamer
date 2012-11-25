
class HomeController < ApplicationController
  require 'google/api_client'
  require 'client_builder'

  # TODO: get the google API query code out of the controller to somewhere else?
  def google_query
    # TODO: Get current datetime from user's browser. Current code relies on the server
    today_start = Date.today.to_time.to_datetime.rfc3339
    today_end = (Date.today.next.to_time - 1.second).to_datetime.rfc3339

    client =  ClientBuilder.get_client(current_user)
    service = client.discovered_api('calendar', 'v3')
    resource = client.execute(:api_method => service.events.list, 
                              :parameters => {
                                'calendarId' => 'primary', 
                                'orderBy' => 'startTime', 
                                'singleEvents' => 'true',
                                # 'timeMin' => '2012-11-05T00:00:00-06:00',
                                # 'timeMax' => '2012-11-05T23:59:59-06:00'
                                'timeMin' => today_start,
                                'timeMax' => today_end
                                }) 
    @api_data = resource.data

    # fake google data for debugging
    # items = [
    #   {"summary"=>"San Diego"}, 
    #   {"location"=>"San Diego"}, 
    #   {"start"=> {"dateTime" => "2012-11-21T00:00:00-06:00"}}, 
    #   {"end" => {"dateTime" => (Date.today.next.to_time - 1.second).to_datetime.rfc3339}}
    # ]
  
    timezone = resource.data["timeZone"]

    resource.data.items.each do |item|
      event_hash = Hash.new
      event_hash[:summary] = item["summary"]
      event_hash[:google_id] = item["id"]
      event_hash[:g_created] = item["created"]
      event_hash[:g_updated] = item["updated"]
      event_hash[:timezone] = timezone
      if item["location"]
        event_hash[:location] = item["location"]
      end
      if item["description"]
        event_hash[:description] = item["description"]
      end
      if item["start"]["dateTime"]
        event_hash[:start] = item["start"]["dateTime"]
        event_hash[:end] = item["end"]["dateTime"]
      else
        event_hash[:start] = item["start"]["date"]
        event_hash[:end] = item["end"]["date"]
      end
      event = current_user.events.new(event_hash)
      event.save 
    end 
  end


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
    current_user.events.destroy_all
    redirect_to root_url, :notice => 'Events refreshed from Google Calendar!'
  end

end



