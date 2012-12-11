# spec/factories/users.rb
require 'faker'

FactoryGirl.define do
  factory :user do |f|
    f.name { Faker::Name.first_name }
  end
end