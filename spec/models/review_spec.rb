# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Review do
  describe 'validations' do
    it 'is valid with valid attributes' do
      review = build(:review)
      expect(review).to be_valid
    end

    it 'is not valid without a review_date' do
      review = build(:review, review_date: nil)
      expect(review).not_to be_valid
    end
  end
end
