# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Doctor do
  describe 'validations' do
    it 'is valid with valid attributes' do
      doctor = build(:doctor)
      expect(doctor).to be_valid
    end

    it 'is not valid with not unique user_id' do
      doctor_one = create(:doctor)
      doctor_two = build(:doctor, user: doctor_one.user)
      expect(doctor_two).not_to be_valid
    end
  end
end
