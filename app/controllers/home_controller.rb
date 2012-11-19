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
                                  'timeMin' => '2012-11-05T00:00:00-06:00',
                                  'timeMax' => '2012-11-05T23:59:59-06:00'
                                  # 'timeMin' => today_start,
                                  # 'timeMax' => today_end
                                  }) 
      @events = resource.data
      # @events = resource.data.as_json
    end

  end
end

