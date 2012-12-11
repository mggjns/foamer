# spec/factories/calendars.rb
require 'faker'

FactoryGirl.define do
  factory :calendar do |f|
    f.summary { Faker::Name.name }
  end
end