class HomeController < ApplicationController
  require 'google/api_client'
  require 'client_builder'
  def index
    if (user_signed_in? )
      client = ClientBuilder.get_client(current_user)
      service = client.discovered_api('calendar', 'v3')
      resource = client.execute(:api_method => service.events.list, 
                                :parameters => {'calendarId' => 'primary'}) 

      @calendars = resource.data
      # @calendars = resource.data.as_json
    end

  end
end



## some debuggin' code for rails console if you want to test manually

# require 'google/api_client'
# require 'client_builder'
# current_user = User.find(1)
# client = ClientBuilder.get_client(current_user)
# service = client.discovered_api('calendar', 'v3')
# resource = client.execute(:api_method => service.events.list, :parameters => {'calendarId' => 'primary'}) 