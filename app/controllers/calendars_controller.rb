class CalendarsController < ApplicationController
  helper_method :get_user_timezone
  helper_method :get_calendars

  before_filter :authenticate_user!

  def calendar_review
    if current_user.calendars.size == 0
      get_calendars
    end
    @calendars = current_user.calendars
  end

  # GET /calendars
  # GET /calendars.json
  def index
    @calendars = Calendar.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @calendars }
    end
  end

  # GET /calendars/1
  # GET /calendars/1.json
  def show
    @calendar = Calendar.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @calendar }
    end
  end

  # GET /calendars/new
  # GET /calendars/new.json
  def new
    @calendar = Calendar.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @calendar }
    end
  end

  # GET /calendars/1/edit
  def edit
    @calendar = Calendar.find(params[:id])
  end

  # POST /calendars
  # POST /calendars.json
  def create
    @calendar = Calendar.new(params[:calendar])

    respond_to do |format|
      if @calendar.save
        format.html { redirect_to @calendar, notice: 'Calendar was successfully created.' }
        format.json { render json: @calendar, status: :created, location: @calendar }
      else
        format.html { render action: "new" }
        format.json { render json: @calendar.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /calendars/1
  # PUT /calendars/1.json
  def update
    @calendar = Calendar.find(params[:id])

    respond_to do |format|
      if @calendar.update_attributes(params[:calendar])
        format.html { redirect_to @calendar, notice: 'Calendar was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @calendar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calendars/1
  # DELETE /calendars/1.json
  def destroy
    @calendar = Calendar.find(params[:id])
    @calendar.destroy

    respond_to do |format|
      format.html { redirect_to calendars_url }
      format.json { head :no_content }
    end
  end

    private
        def get_user_timezone
          client =  ClientBuilder.get_client(current_user)
          service = client.discovered_api('calendar', 'v3')
          resource = client.execute(:api_method => service.calendars.get, 
                                    :parameters => {
                                      'calendarId' => 'primary', 
                                      }) 
          current_user.timezone = resource.data["timeZone"]
          current_user.save
        end

        def get_calendars
          # delete any existing calendars (for when we refresh)
          current_user.calendars.destroy_all

          # get user's timezone from their primary calendar
          if !current_user.timezone
              get_user_timezone
          end

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

    end

end
