# frozen_string_literal: true

FactoryBot.define do
  factory :review do
    user { FactoryBot.create(:user) }
    doctor { FactoryBot.create(:doctor) }
    review_date { Faker::Date.between(from: Time.zone.today, to: 7.days.from_now) }
  end
end
