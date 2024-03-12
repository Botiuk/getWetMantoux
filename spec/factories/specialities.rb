FactoryBot.define do
    factory :speciality do
        name  { Faker::Job.unique.field }
        description { Faker::Movies::StarWars.wookiee_sentence }
    end
end
