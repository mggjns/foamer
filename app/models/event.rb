class Event < ActiveRecord::Base
  attr_accessible :end, :g_created, :g_updated, :google_id, :latitude, :location, :longitude, :start, :summary, :timezone, :description, :recurringEventId, :skip
  geocoded_by :location
  after_validation :geocode
  belongs_to :calendar

end
