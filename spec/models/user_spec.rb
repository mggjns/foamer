# spec/models/user.rb
require 'spec_helper'

describe User do
  it "has a valid factory" do
  	FactoryGirl.build(:user).should be_valid
  end
  it "is invalid without a name" do
  	FactoryGirl.build(:user, name: nil).should_not be_valid
	end
  it "is invalid without a unique UID" do
  	# user = FactoryGirl.(:user)
  	FactoryGirl.create(:user, uid: "112280")
  	FactoryGirl.build(:user, uid: "112280").should_not be_valid
  end
  it "returns a user's calendars" do
  	user = FactoryGirl.create(:user)
  	user.calendars
  end
  it "returns a user's events" do
  	user = FactoryGirl.create(:user)
  	user.events
  end
  it "returns a user's 5 calendars" do
  	user = FactoryGirl.create(:user, uid: "112280")
  	5.times { FactoryGirl.create(:calendar, user_id: user) }
  	
  	user.calendars.size.should == "5"
  end
end