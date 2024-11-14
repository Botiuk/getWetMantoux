# frozen_string_literal: true

FactoryBot.define do
  factory :speciality do
    name { Faker::Music.unique.band }
    description { Faker::Movies::StarWars.wookiee_sentence }
  end
end
