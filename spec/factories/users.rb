# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    phone { Faker::Number.unique.number(digits: 8) }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
