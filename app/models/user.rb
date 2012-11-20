class User < ActiveRecord::Base
  attr_accessible :email, :name, :provider, :refresh_token, :token, :token_expires_at, :uid
  has_many :places
  has_many :events

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
