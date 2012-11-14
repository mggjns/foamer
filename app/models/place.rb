class Place < ActiveRecord::Base
  attr_accessible :city, :desc, :name, :state, :street, :user_id, :zip
end
