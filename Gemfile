source 'https://rubygems.org'


gem 'rails', '3.2.8'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# for deployment on Heroku
group :development, :test do
	gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'spork'
  gem 'spork-rails'
  gem 'factory_girl_rails'
end

group :test do
  gem 'capybara'
  gem 'rb-fsevent', :require => false
  gem 'terminal-notifier-guard'
  gem 'faker'
  gem 'launchy'
end 

group :production do
  gem 'pg'
end



# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

group :development, :test do
	gem "seed_dump"
end

gem "omniauth", ">= 1.0.3"
gem "omniauth-google-oauth2"
gem 'google_oauth_calendar'
gem "google-api-client"
gem "gcal4ruby"
gem 'pry'
gem "rails-pry"
# Use Thin webserver instead of Webrick. 
gem 'thin'
gem 'geocoder' 

