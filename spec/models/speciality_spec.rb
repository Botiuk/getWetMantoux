# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Speciality do
  describe 'validations' do
    it 'is valid with valid attributes' do
      speciality = build(:speciality)
      expect(speciality).to be_valid
    end

    it 'is valid with without description' do
      speciality = build(:speciality, description: nil)
      expect(speciality).to be_valid
    end

    it 'is not valid without a name' do
      speciality = build(:speciality, name: nil)
      expect(speciality).not_to be_valid
    end

    it 'is not valid with a small first letter in name' do
      speciality = build(:speciality, name: 'science')
      expect(speciality).not_to be_valid
    end

    it 'is not valid with a small first letter in description' do
      speciality = build(:speciality, description: 'it About Something')
      expect(speciality).not_to be_valid
    end

    it 'is not valid with not unique name' do
      speciality_one = create(:speciality)
      speciality_two = build(:speciality, name: speciality_one.name)
      expect(speciality_two).not_to be_valid
    end
  end
end
