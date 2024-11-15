# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Specialities' do
  describe 'non registered user management' do
    it 'can GET index' do
      get specialities_path
      expect(response).to be_successful
    end

    it 'can GET belonging_doctors, speciality has doctor with personal card' do
      speciality = create(:speciality)
      doctor = create(:doctor, speciality: speciality)
      create(:personal_card, user: doctor.user)
      get specialities_belonging_doctors_path(id: speciality.id)
      expect(response).to be_successful
      expect(response.body).to include speciality.name
      expect(response.body).to include doctor.personal_card.last_name
    end

    it 'can GET belonging_doctors, speciality hasnot doctor' do
      speciality = create(:speciality)
      get specialities_belonging_doctors_path(id: speciality.id)
      expect(response).to be_successful
      expect(response.body).to include speciality.name
      expect(response.body).to include I18n.t('specialities.belonging_doctors.doctors_empty')
    end

    it 'cannot GET new and redirects to the sign_in page' do
      get new_speciality_path
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to include I18n.t('devise.failure.unauthenticated')
    end

    it 'cannot GET edit and redirects to the sign_in page' do
      speciality = create(:speciality)
      get edit_speciality_path(speciality)
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to include I18n.t('devise.failure.unauthenticated')
    end
  end

  describe 'user-admin management' do
    before do
      admin_user = create(:user, role: 'admin')
      create(:personal_card, user: admin_user)
      login_as(admin_user, scope: :user)
    end

    it 'can GET new and POST create' do
      get new_speciality_path
      expect(response).to be_successful

      post specialities_path, params: { speciality: attributes_for(:speciality) }
      expect(response).to be_redirect
      follow_redirect!
      expect(flash[:notice]).to include I18n.t('notice.create.speciality')
    end

    it 'can GET edit and PUT update' do
      speciality = create(:speciality, name: 'New speciality')
      get edit_speciality_path(speciality)
      expect(response).to be_successful

      put speciality_path(speciality), params: { speciality: { name: 'Edit speciality' } }
      expect(speciality.reload.name).to eq('Edit speciality')
      expect(response).to redirect_to(specialities_url)
      expect(flash[:notice]).to include(I18n.t('notice.update.speciality'))
    end
  end

  describe 'user-doctor-not-fired management' do
    before do
      doctor_user = create(:user, role: 'doctor')
      create(:personal_card, user: doctor_user)
      create(:doctor, user: doctor_user)
      login_as(doctor_user, scope: :user)
    end

    it 'cannot GET new and redirects to the root page' do
      get new_speciality_path
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it 'cannot GET edit and redirects to the root page' do
      speciality = create(:speciality)
      get edit_speciality_path(speciality)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end
  end

  describe 'user-doctor-fired management' do
    before do
      doctor_user = create(:user, role: 'doctor')
      create(:personal_card, user: doctor_user)
      create(:doctor, user: doctor_user, doctor_status: 'fired')
      login_as(doctor_user, scope: :user)
    end

    it 'cannot GET new and redirects to the root page' do
      get new_speciality_path
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it 'cannot GET edit and redirects to the root page' do
      speciality = create(:speciality)
      get edit_speciality_path(speciality)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end
  end

  describe 'user-user management' do
    before do
      user_user = create(:user)
      create(:personal_card, user: user_user)
      login_as(user_user, scope: :user)
    end

    it 'cannot GET new and redirects to the root page' do
      get new_speciality_path
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it 'cannot GET edit and redirects to the root page' do
      speciality = create(:speciality)
      get edit_speciality_path(speciality)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end
  end
end
