class Place < ActiveRecord::Base
  attr_accessible :desc, :name, :address, :user_id, :latitude, :longitude 
  geocoded_by :address
  after_validation :geocode 
  belongs_to :user

end
