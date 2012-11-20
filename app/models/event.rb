# TODO: Store user events in this model.
class Event < ActiveRecord::Base
  attr_accessible :address, :begins, :ends, :latitude, :longitude, :name, :user_id
  geocoded_by :address
  after_validation :geocode 
  belongs_to :user
end
