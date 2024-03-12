require 'rails_helper'

RSpec.describe User, type: :model do

    describe "validations" do

        it "is valid with valid attributes" do
            user = build(:user)
            expect(user).to be_valid
        end

        it "is not valid without a password" do
            user = build(:user, password: nil)
            expect(user).to_not be_valid
        end

        it "is not valid with too short phone" do
            user = build(:user, phone: "12345")
            expect(user).to_not be_valid
        end

        it "is not valid with too long phone" do
            user = build(:user, phone: "123456789101112131415")
            expect(user).to_not be_valid
        end

        it "is not valid with letters in phone number" do
            user = build(:user, phone: "123sfdgffg")
            expect(user).to_not be_valid
        end

        it "is not valid with not unique phone" do
            user = create(:user, phone: "123456709878")
            user_two = build(:user, phone: "123456709878")
            expect(user_two).to_not be_valid
        end
    end

    describe "set_default_role" do
        it "role user if role empty" do
            user = build(:user)
            expect(user.role).to eq("user")
        end

        it "role that put when create" do
            user = build(:user, role: "admin")
            expect(user.role).to eq("admin")
        end

        it "role that put when change" do
            user = build(:user)
            user.role = "doctor"
            expect(user.role).to eq("doctor")
        end
    end

end
