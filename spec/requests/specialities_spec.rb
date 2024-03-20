require 'rails_helper'

RSpec.describe "Specialities", type: :request do
  describe "non registered user management" do
    it "can read index" do
      visit '/specialities'
      expect(current_path).to eq(specialities_path)
    end

    it "can read speciality belonging_doctors, speciality has doctor with personal card" do
      speciality = FactoryBot.create(:speciality)
      doctor = FactoryBot.create(:doctor, speciality: speciality)
      FactoryBot.create(:personal_card, user: doctor.user)
      visit "/specialities/belonging_doctors?id=#{speciality.id}"
      expect(page).to have_text speciality.name
      expect(page).to have_text doctor.personal_card.last_name
    end

    it "can read speciality belonging_doctors, speciality hasnot doctor" do
      speciality = FactoryBot.create(:speciality)
      visit "/specialities/belonging_doctors?id=#{speciality.id}"
      expect(page).to have_text speciality.name
      expect(page).to have_text I18n.t('specialities.belonging_doctors.doctors_empty')
    end

    it "cannot creates speciality and redirects to the sign_in page" do
      visit '/specialities/new'
      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_text I18n.t('devise.failure.unauthenticated')
    end

    it "cannot updates speciality and redirects to the sign_in page" do
      speciality = FactoryBot.create(:speciality)
      visit "/specialities/#{speciality.id}/edit"
      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_text I18n.t('devise.failure.unauthenticated')
    end
  end

  describe "user-admin management" do
    before :each do
      admin_user = FactoryBot.create(:user, role: "admin")
      FactoryBot.create(:personal_card, user: admin_user)
      login_as(admin_user, :scope => :user)
    end

    it "creates speciality and redirects to the specialities page" do
      visit '/specialities/new'
        fill_in I18n.t('specialities.form.name'), with: "Family doctor"
        fill_in I18n.t('specialities.form.description'), with: "Some description about family doctor speciality"
        click_button I18n.t('button.submit')
      expect(current_path).to eq(specialities_path)
      expect(page).to have_text I18n.t('notice.create.speciality')
    end

    it "updates speciality and redirects to the specialities page" do
      speciality = FactoryBot.create(:speciality)
      visit "/specialities/#{speciality.id}/edit"
        fill_in I18n.t('specialities.form.name'), with: "Edit speciality"
        click_button I18n.t('button.submit')
      expect(current_path).to eq(specialities_path)
      expect(page).to have_text I18n.t('notice.update.speciality')
    end

  end

  describe "user-doctor-not-fired management" do
    before :each do
      doctor_user = FactoryBot.create(:user, role: "doctor")
      FactoryBot.create(:personal_card, user: doctor_user)
      FactoryBot.create(:doctor, user: doctor_user)
      login_as(doctor_user, :scope => :user)
    end

    it "cannot creates and redirects to the root page" do
      visit '/specialities/new'
      expect(current_path).to eq(root_path)
      expect(page).to have_text I18n.t('alert.access_denied')
    end

    it "cannot updates speciality and redirects to the root page" do
      speciality = FactoryBot.create(:speciality)
      visit "/specialities/#{speciality.id}/edit"
      expect(current_path).to eq(root_path)
      expect(page).to have_text I18n.t('alert.access_denied')
    end
  end

  describe "user-doctor-fired management" do
    before :each do
      doctor_user = FactoryBot.create(:user, role: "doctor")
      FactoryBot.create(:personal_card, user: doctor_user)
      FactoryBot.create(:doctor, user: doctor_user, doctor_status: "fired")
      login_as(doctor_user, :scope => :user)
    end

    it "cannot creates and redirects to the root page" do
      visit '/specialities/new'
      expect(current_path).to eq(root_path)
      expect(page).to have_text I18n.t('alert.access_denied')
    end

    it "cannot updates speciality and redirects to the root page" do
      speciality = FactoryBot.create(:speciality)
      visit "/specialities/#{speciality.id}/edit"
      expect(current_path).to eq(root_path)
      expect(page).to have_text I18n.t('alert.access_denied')
    end
  end

  describe "user-user management" do
    before :each do
      user_user = FactoryBot.create(:user)
      FactoryBot.create(:personal_card, user: user_user)
      login_as(user_user, :scope => :user)
    end

    it "cannot creates and redirects to the root page" do
      visit '/specialities/new'
      expect(current_path).to eq(root_path)
      expect(page).to have_text I18n.t('alert.access_denied')
    end

    it "cannot updates speciality and redirects to the root page" do
      speciality = FactoryBot.create(:speciality)
      visit "/specialities/#{speciality.id}/edit"
      expect(current_path).to eq(root_path)
      expect(page).to have_text I18n.t('alert.access_denied')
    end
  end

end
