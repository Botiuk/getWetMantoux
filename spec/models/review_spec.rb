require 'rails_helper'

RSpec.describe Review, type: :model do
    describe "validations" do

        it "is valid with valid attributes" do
            review = build(:review)
            expect(review).to be_valid
        end

        it "is not valid without a review_date" do
            review = build(:review, review_date: nil )
            expect(review).to_not be_valid
        end
    end
end
