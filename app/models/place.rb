class Place < ActiveRecord::Base
  attr_accessible :desc, :name, :address, :user_id
  belongs_to :user
end
