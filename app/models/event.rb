class Event < ActiveRecord::Base
  attr_accessible :end, :g_created, :g_updated, :google_id, :latitude, :location, :longitude, :start, :summary, :timezone, :user_id, :description
  geocoded_by :location
  after_validation :geocode
  belongs_to :user
  belong_to :user
end
