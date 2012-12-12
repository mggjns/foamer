class Event < ActiveRecord::Base
  attr_accessible :end, :g_created, :g_updated, :google_id, :latitude, :location, :longitude, :start, :summary, :timezone, :description, :recurringEventId, :skip, :calendar_id
  geocoded_by :location
  after_validation :geocode, :if => :location_changed?
  belongs_to :calendar

end
