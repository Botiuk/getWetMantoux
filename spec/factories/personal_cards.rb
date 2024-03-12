FactoryBot.define do
    factory :personal_card do
        user { FactoryBot.create(:user) }
        last_name { Faker::Name.last_name }
        first_name { Faker::Name.first_name }
        middle_name { Faker::Name.middle_name }
        date_of_birth { Faker::Date.between(from: 100.year.ago, to: Date.today) }
    end
end
