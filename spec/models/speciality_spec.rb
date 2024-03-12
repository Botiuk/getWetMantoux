require 'rails_helper'

RSpec.describe Speciality, type: :model do

    describe "validations" do

        it "is valid with valid attributes" do
            speciality = build(:speciality)
            expect(speciality).to be_valid
        end

        it "is valid with without description" do
            speciality = build(:speciality, description: nil)
            expect(speciality).to be_valid
        end

        it "is not valid without a name" do
            speciality = build(:speciality, name: nil)
            expect(speciality).to_not be_valid
        end

        it "is not valid with a small first letter in name" do
            speciality = build(:speciality, name: "science")
            expect(speciality).to_not be_valid
        end

        it "is not valid with a small first letter in description" do
            speciality = build(:speciality, description: "it About Something")
            expect(speciality).to_not be_valid
        end

        it "is not valid with not unique name" do
            speciality = create(:speciality, name: "Science")
            speciality_two = build(:speciality, name: "Science")
            expect(speciality_two).to_not be_valid
        end
    end

end
