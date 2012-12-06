class Calendar < ActiveRecord::Base
  attr_accessible :access_role, :active, :background_color, :color_id, :description, :etag, :foreground_color, :google_id, :kind, :selected, :summary, :time_zone
  has_many :events
  belongs_to :user
end
