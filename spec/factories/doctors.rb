FactoryBot.define do
    factory :doctor do
        user { FactoryBot.create(:user, role: "doctor") }
        speciality { FactoryBot.create(:speciality) }
        doctor_status { "working" }        
    end
end
