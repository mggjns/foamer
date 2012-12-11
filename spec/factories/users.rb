# spec/factories/users.rb
require 'faker'

FactoryGirl.define do
  factory :user do |f|
    f.name { Faker::Name.name }
    f.email { Faker::Internet.email }
    f.uid { rand(10000..60000) }
  end
end