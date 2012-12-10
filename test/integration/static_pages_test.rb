require 'spec_helper'

describe "Static pages" do

  describe "Signin page" do

    it "should have the content 'Sample App'" do
      visit '/signin'
      page.should have_content('Sample App')
    end
  end
end