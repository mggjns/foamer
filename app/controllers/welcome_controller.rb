class WelcomeController < ApplicationController

	before_filter :authenticate_user!
	
	def initial_page
		if !current_user.timezone
        get_user_timezone_from_google_calendar
    end
		
	end

	def calendars
		@calendars = current_user.calendars
		@rad = @all_calendars
		
	end

	def get_calendars
	   		# delete any existing calendars (for when we refresh)
	   		current_user.calendars.destroy_all

	      client =  ClientBuilder.get_client(current_user)
	      service = client.discovered_api('calendar', 'v3')
	      resource = client.execute(:api_method => service.calendar_list.list)
	      @all_calendars = resource.data 

	      resource.data.items.each do |item|
	        calendar_hash = Hash.new
	        calendar_hash[:kind] = item["kind"]
	        calendar_hash[:google_id] = item["id"]
	        calendar_hash[:etag] = item["etag"]
	        calendar_hash[:summary] = item["summary"]
	        if calendar_hash[:description]
		        calendar_hash[:description] = item["description"]
		      end
	        calendar_hash[:time_zone] = item["time_zone"]
	        calendar_hash[:color_id] = item["color_id"]
	        calendar_hash[:background_color] = item["background_color"]
	        calendar_hash[:foreground_color] = item["foreground_color"]
	        calendar_hash[:selected] = item["selected"]
	        calendar_hash[:access_role] = item["access_role"]
	        calendar_hash[:active] = item["active"]
	  
	        calendar = current_user.calendars.new(calendar_hash)
	        calendar.save
	      end
    redirect_to calendars_path

	end

	  # TODO: refactor this into general purpose API query method where we can pass which google API/resources/params
  def get_events
    # TODO: Get current datetime from user's browser. Current code relies on the server
    today_start = DateTime.now.in_time_zone(current_user.timezone).to_datetime.at_beginning_of_day.rfc3339
    today_end = DateTime.now.in_time_zone(current_user.timezone).to_datetime.end_of_day.rfc3339

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
      event_hash[:google_id] = item["id"]
      event_hash[:g_created] = item["created"]
      event_hash[:g_updated] = item["updated"]
      # event_hash[:timezone] = timezone
      if item["recurringEventId"].present?
        event_hash[:recurringEventId] = item["recurringEventId"]
      end
      if item["location"].present?
        event_hash[:location] = item["location"]
      end
      if item["description"].present?
        event_hash[:description] = item["description"]
      end
      if item["start"]["dateTime"].present?
        event_hash[:start] = item["start"]["dateTime"]
        event_hash[:end] = item["end"]["dateTime"]
      else
        event_hash[:start] = item["start"]["date"]
        event_hash[:end] = item["end"]["date"]
      end
      event = current_user.events.new(event_hash)
      event.save 
	  end 

  redirect_to home_path

	end

	private
	    def get_user_timezone_from_google_calendar
	      client =  ClientBuilder.get_client(current_user)
	      service = client.discovered_api('calendar', 'v3')
	      resource = client.execute(:api_method => service.calendars.get, 
	                                :parameters => {
	                                  'calendarId' => 'primary', 
	                                  }) 
	      current_user.timezone = resource.data["timeZone"]
	      current_user.save
	    end

end
