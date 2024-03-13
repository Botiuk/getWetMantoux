require 'rails_helper'

RSpec.describe "Specialities", type: :request do
  describe "non registered user management" do
    it "can read index" do
      visit '/specialities'
      expect(current_path).to eq(specialities_path)
    end

    it "cannot creates and redirects to the sign_in page" do
      visit '/specialities/new'
      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_text(I18n.t('devise.failure.unauthenticated'))
    end

    it "cannot updates speciality and redirects to the sign_in page" do
      speciality = Speciality.create(name: "New speciality")
      visit "/specialities/#{speciality.id}/edit"

      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_text(I18n.t('devise.failure.unauthenticated'))
    end
  end

  describe "user-admin management" do
    before :each do
      admin_user = User.create(phone: "0987654", password: "password", role: "admin")
      PersonalCard.create(user_id: admin_user.id, last_name: "Admin", first_name: "Admin", date_of_birth: "2000-01-01")
      visit '/users/sign_in'
      fill_in 'user_phone', with: "0987654"
      fill_in 'user_password', with: "password"
      click_button I18n.t('users.sessions.new.log_in')
    end

    it "creates speciality and redirects to the specialities page" do
      visit '/specialities/new'
      expect(current_path).to eq(new_speciality_path)
      fill_in I18n.t('specialities.form.name'), with: "Family doctor"
      fill_in I18n.t('specialities.form.description'), with: "Some description about family doctor speciality"
      click_button I18n.t('button.submit')

      expect(current_path).to eq(specialities_path)
      expect(page).to have_text(I18n.t('notice.create.speciality'))
    end

    it "updates speciality and redirects to the specialities page" do
      speciality = Speciality.create(name: "New speciality")
      visit "/specialities/#{speciality.id}/edit"
      expect(current_path).to eq(edit_speciality_path(speciality))
      fill_in I18n.t('specialities.form.name'), with: "Edit speciality"
      click_button I18n.t('button.submit')

      expect(current_path).to eq(specialities_path)
      expect(page).to have_text(I18n.t('notice.update.speciality'))
    end
  end

  describe "user-doctor management" do
    before :each do
      doctor_user = User.create(phone: "123098", password: "password", role: "doctor")
      PersonalCard.create(user_id: doctor_user.id, last_name: "Doctor", first_name: "Doctor", date_of_birth: "2000-01-01")
      visit '/users/sign_in'
      fill_in 'user_phone', with: "123098"
      fill_in 'user_password', with: "password"
      click_button I18n.t('users.sessions.new.log_in')
    end

    it "cannot creates and redirects to the root page" do
      visit '/specialities/new'
      expect(current_path).to eq(root_path)
      expect(page).to have_text(I18n.t('alert.access_denied'))
    end

    it "cannot updates speciality and redirects to the root page" do
      speciality = Speciality.create(name: "New speciality")
      visit "/specialities/#{speciality.id}/edit"

      expect(current_path).to eq(root_path)
      expect(page).to have_text(I18n.t('alert.access_denied'))
    end
  end

  describe "user-user management" do
    before :each do
      user_user = User.create(phone: "678905", password: "password")
      PersonalCard.create(user_id: user_user.id, last_name: "User", first_name: "User", date_of_birth: "2000-01-01")
      visit '/users/sign_in'
      fill_in 'user_phone', with: "678905"
      fill_in 'user_password', with: "password"
      click_button I18n.t('users.sessions.new.log_in')
    end

    it "cannot creates and redirects to the root page" do
      visit '/specialities/new'
      expect(current_path).to eq(root_path)
      expect(page).to have_text(I18n.t('alert.access_denied'))
    end

    it "cannot updates speciality and redirects to the root page" do
      speciality = Speciality.create(name: "New speciality")
      visit "/specialities/#{speciality.id}/edit"

      expect(current_path).to eq(root_path)
      expect(page).to have_text(I18n.t('alert.access_denied'))
    end
  end

end
