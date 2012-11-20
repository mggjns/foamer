# TODO: Can we cache the API query to Google somehow, so to speed things up?
class HomeController < ApplicationController
  require 'google/api_client'
  require 'client_builder'
  def index

    # Get start and end times (today) and account for timezones, and 
    # return in RFC3339 format which the API uses 
    today_start = Date.today.to_time.to_datetime.rfc3339
    today_end = (Date.today.next.to_time - 1.second).to_datetime.rfc3339

    if (user_signed_in? )
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
      @events = []
      
      # TODO: Consider creating an event class to work with our event data

      resource.data.items.each do |item|
        hash = Hash.new
        hash[:summary] = item["summary"]
        if item["location"]
          hash[:location] = item["location"]
        end
        if item["start"]["dateTime"]
          hash[:start] = item["start"]["dateTime"]
          hash[:end] = item["end"]["dateTime"]
        else
          hash[:start] = item["start"]["date"]
          hash[:end] = item["end"]["date"]
        end
        @events.push(hash)
      end






      # @events = resource.data.as_json
    end

  end
end

