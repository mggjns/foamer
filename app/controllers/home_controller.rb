# TODO: Can we cache the API query to Google somehow, so to speed things up?
class HomeController < ApplicationController
  require 'google/api_client'
  require 'client_builder'

  def index

    # Get start and end times (today) and account for timezones, and 
    # return in RFC3339 format which the API uses 
    # TODO: Get current datetime from user's browser. This relies on the server
    today_start = Date.today.to_time.to_datetime.rfc3339
    today_end = (Date.today.next.to_time - 1.second).to_datetime.rfc3339

    if (user_signed_in? )
      # Only query Google Calendar API if we don't have any events in the DB
      if current_user.events.size == 0
        # turning off Google for debugging
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
        
        resource.data.items.each do |item|
          event_hash = Hash.new
          event_hash[:summary] = item["summary"]
          if item["location"]
            event_hash[:location] = item["location"]
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

      # Fetch user's events from the DB
      @events = current_user.events


    end

  end
end

