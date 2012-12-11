require 'spec_helper'

describe "Redirect to Signin Page" do

  describe "Calendars" do

    it "should have the content 'Sign in with your Google account to start'" do
      visit '/signin'
      page.should have_content('Sign in with your Google account to start')
    end
  end
end