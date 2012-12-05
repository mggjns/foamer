# TODO: gotta handle situations where events from user's calendar doesn't have an address.

class EventsController < ApplicationController
  require 'google/api_client'
  require 'client_builder'

  before_filter :authenticate_user!, :except => [:default]

  # root url
  def home
        # Get the user's timezone from their primary Google Calendar.
      # Supposedly you can pull the user timezone when you first authorize via Oauth2,
      # but the response doesn't actually provide the timezone, despite what the docs
      # say here: https://developers.google.com/accounts/docs/OAuth2Login#userinfocall
      if !current_user.timezone
        get_user_timezone_from_google_calendar
      end

      # TODO: We have a problem of stale cookie here, among other things
      if (cookies[:lat_lng])
        @lat_lng = cookies[:lat_lng].split("|")
        # See if we have a Current Location in Place, and update coordinates if so. Otherwise, create.
        if location = current_user.places.find_by_name("Current Location")
           location.update_attributes(:address => "#{@lat_lng[0]}, #{@lat_lng[1]}", 
                                      :latitude => @lat_lng[0], 
                                      :longitude => @lat_lng[1])
        else
          current_user.places.create(:name => "Current Location",
                                      :address => "#{@lat_lng[0]}, #{@lat_lng[1]}", 
                                      :latitude => @lat_lng[0], 
                                      :longitude => @lat_lng[1])
        end
      end

      # Only query Google Calendar API if we don't have any events in the DB
      # TODO: What if a user doesn't have any events today in their Google Calendar?
      if current_user.events.where("start >= ?", Date.today).size == 0
        google_query
      end

      # Grab user's events starting at the current time, then paginate with Kaminari
      @events = current_user.events.where("start >= ?", Date.today).page(params[:page]).per(1)
      @places = current_user.places

      # TODO: testing gon, comment this out soon.
      @addresses = ["1047 W. Webster Avenue", "222 Merchandise Mart Plaza", "Midway International Airport"]
      gon.addresses = @addresses

      # if event_locations_need_address = u.events.where(:location => nil)
        # redirect to page add addresses to events with some event edit form
        ## -> form then redirects back here
        ## -> find next location that is blank, go back to event form
        # once there are no more nil locations, render the view

      # end

    
  end


  # GET /events
  # GET /events.json
  def index
    @events = current_user.events.where("start >= ?", Date.today).page(params[:page]).per(3)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    @event = current_user.events.new(params[:event])

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  def refresh
    # TODO: Instead of destroying all, compare events at Google to what we grabbed and if changed, update
    current_user.events.destroy_all
    redirect_to home_url, :notice => 'Events refreshed from Google Calendar!'
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

    # TODO: refactor this into general purpose API query method where we can pass which google API/resources/params
    def google_query
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

end
