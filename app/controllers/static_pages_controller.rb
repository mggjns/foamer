class StaticPagesController < ApplicationController
	
	before_filter :authenticate_user!, :except => ["signin"]

	def signin
	end

	def welcome
	end

end
