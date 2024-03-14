require 'rails_helper'

RSpec.describe Doctor, type: :model do
    describe "validations" do

        it "is valid with valid attributes" do
            doctor = build(:doctor)
            expect(doctor).to be_valid
        end

        it "is not valid with not unique user_id" do
            doctor_one = create(:doctor)
            doctor_two = build(:doctor, user: doctor_one.user)
            expect(doctor_two).to_not be_valid
        end
    end
end
