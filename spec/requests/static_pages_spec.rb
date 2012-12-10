require 'spec_helper'

describe "Static pages" do

  describe "Signin page" do

    it "should have the content 'Sign in with your Google account to start'" do
      visit '/signin'
      page.should have_content('Sign in with your Google account to start')
    end
  end
end