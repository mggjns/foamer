class WelcomeController < ApplicationController

	before_filter :authenticate_user!
	
	def greeting
	end


end
