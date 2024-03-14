FactoryBot.define do
    factory :review do
        user { FactoryBot.create(:user) }
        doctor { FactoryBot.create(:doctor) }
        review_date { Faker::Date.between(from: Date.today, to: 7.days.from_now) }        
    end
end
