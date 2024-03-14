require 'rails_helper'

RSpec.describe PersonalCard, type: :model do

    describe "validations" do

        it "is valid with valid attributes" do
            personal_card = build(:personal_card)
            expect(personal_card).to be_valid
        end

        it "is valid with without middle_name" do
            personal_card = build(:personal_card, middle_name: nil)
            expect(personal_card).to be_valid
        end

        it "is not valid without a user_id" do
            personal_card = build(:personal_card, user: nil)
            expect(personal_card).to_not be_valid
        end

        it "is not valid without a last_name" do
            personal_card = build(:personal_card, last_name: nil)
            expect(personal_card).to_not be_valid
        end

        it "is not valid without a first_name" do
            personal_card = build(:personal_card, first_name: nil)
            expect(personal_card).to_not be_valid
        end

        it "is not valid without a date_of_birth" do
            personal_card = build(:personal_card, date_of_birth: nil)
            expect(personal_card).to_not be_valid
        end

        it "is not valid with a small first letter in last_name" do
            personal_card = build(:personal_card, last_name: "thomson")
            expect(personal_card).to_not be_valid
        end

        it "is not valid with a small first letter in first_name" do
            personal_card = build(:personal_card, first_name: "mike")
            expect(personal_card).to_not be_valid
        end

        it "is not valid with a small first letter in middle_name" do
            personal_card = build(:personal_card, middle_name: "jake")
            expect(personal_card).to_not be_valid
        end

        it "is not valid with not unique user_id" do
            personal_card_one = create(:personal_card)
            personal_card_two = build(:personal_card, user: personal_card_one.user)
            expect(personal_card_two).to_not be_valid
        end
    end

end
