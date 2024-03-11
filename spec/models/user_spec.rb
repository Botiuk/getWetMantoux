require 'rails_helper'

RSpec.describe User, type: :model do

  describe "validations" do
    user = User.new(phone: "1234567", password: "password")

    it "is valid with valid attributes" do
      expect(user).to be_valid
    end

    it "is not valid without a password" do
      user.password = nil
      expect(user).to_not be_valid
    end

    it "is not valid with too short phone" do
      user.phone = "12345"
      expect(user).to_not be_valid
    end

    it "is not valid with too long phone" do
      user.phone = "12345678901234567890"
      expect(user).to_not be_valid
    end

    it "is not valid with letters in phone number" do
      user.phone = "123klpihj"
      expect(user).to_not be_valid
    end

    it "is not valid with not unique phone" do
      user = User.create!(phone: "1234567", password: "password")
      user_two = User.new(phone: "1234567", password: "password")
      expect(user_two).to_not be_valid
    end
  end

  describe "set_default_role" do
    it "role user if role empty" do
      user = User.create(phone: "1234567", password: "password")
      expect(user.role).to eq("user")
    end

    it "role that put when create" do
      user = User.create(phone: "1234567", password: "password", role: "admin")
      expect(user.role).to eq("admin")
    end

    it "role that put when change" do
      user = User.create(phone: "1234567", password: "password")
      user.role = "doctor"
      expect(user.role).to eq("doctor")
    end
  end

end
