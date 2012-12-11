class User < ActiveRecord::Base
  attr_accessible :email, :name, :provider, :refresh_token, :token, :token_expires_at, :uid, :timezone, :travel_mode

  validates :name, :presence => true
  validates :email, :uid, :uniqueness => true
  has_many :places
  has_many :calendars

  has_many :events, :through => :calendars

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      if auth['info']
         user.name = auth['info']['name'] || ""
         user.email = auth['info']['email'] || ""
      end
    end
  end
end
