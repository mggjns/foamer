# TODO: gotta handle situations where events from user's calendar doesn't have an address.

class EventsController < ApplicationController
  require 'google/api_client'
  require 'client_builder'
  
  before_filter :authenticate_user!
  

  def got_nothing
  end

  def event_review
    get_events
    event_check
  end

    def travel_mode
    end

  # root url
  def home

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

      # If no calendars for some reason, take the user to CalendarController#calendar_review
      if current_user.calendars.size == 0
        redirect_to calendar_review_path
      end

      # If no events found in our database, show got_nothing page where user can try refreshing from Google.
      if current_user.events.where("start >= ? AND events.skip = ?", Time.now.in_time_zone(current_user.timezone), false).size == 0
        redirect_to got_nothing_url
      else
        # TODO: Every time we load the page, we have a database hit to load the events. Decouple this from the view generation.
        @events = current_user.events.where("start >= ? AND events.skip = ?", Time.now.in_time_zone(current_user.timezone), false).order("start ASC")
        
        # set travel_mode to be used in forms to user's saved preference
        # TODO: set this once per session and not hit database every time
        if current_user.travel_mode
          session[:travel_mode] = current_user.travel_mode
        else 
          session[:travel_mode] = "DRIVING"
        end
        # Get list of user's saved places, not meaningfully used yet
        @places = current_user.places
      end
  end


  # GET /events
  # GET /events.json
  def index
    @events = current_user.events.where("start >= ?", Date.today)

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
        format.js { head :no_content }
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
    get_events
    redirect_to event_review_path, :notice => 'Events refreshed from Google Calendar!'
  end


  private

      # TODO: refactor this into general purpose API query method where we can pass which google API/resources/params
    def get_events

      # Delete all current events, we're going to query google and grab a fresh list
      # TODO: Instead of destroying all, compare events at Google to what we grabbed and if changed, update
      current_user.calendars.map {|x| x.events.destroy_all}

      today_start = DateTime.now.in_time_zone(current_user.timezone).to_datetime.at_beginning_of_day.rfc3339
      today_end = DateTime.now.in_time_zone(current_user.timezone).to_datetime.end_of_day.rfc3339

      current_user.calendars.where("active = ?", true).each do |calendar|

        client =  ClientBuilder.get_client(current_user)
        service = client.discovered_api('calendar', 'v3')
        resource = client.execute(:api_method => service.events.list, 
                                  :parameters => {
                                    'calendarId' => calendar.google_id, 
                                    'orderBy' => 'startTime', 
                                    'singleEvents' => 'true',
                                    # 'timeMin' => '2012-11-05T00:00:00-06:00',
                                    # 'timeMax' => '2012-11-05T23:59:59-06:00'
                                    'timeMin' => today_start,
                                    'timeMax' => today_end
                                    }) 
        @api_data = resource.data
      
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
          event_hash[:skip] = false
          event = calendar.events.new(event_hash)
          event.save 
        end

      end 
      # TODO: we might add more of the same events to the database. Need a check.
      @events_today = current_user.events.where("start >= ?", Date.today).order("start ASC")
    end

    def event_check
      # Cycle through events and see if lat/long are missing, which means we don't have an address.
      if @events_today.where(:skip => false).size == 0
        redirect_to got_nothing_url
      else
        @events_no_address = []
        @events_today.each do |event|
          if event.latitude.nil? || event.longitude.nil?
            @events_no_address.push(event)
          end
        end
      end
    end

 end
