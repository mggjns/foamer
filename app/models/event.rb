class Event < ActiveRecord::Base
  attr_accessible :end, :g_created, :g_updated, :google_id, :latitude, :location, :longitude, :start, :summary, :timezone, :user_id
end
