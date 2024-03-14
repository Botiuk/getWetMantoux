require 'rails_helper'

RSpec.feature "Reviews", type: :feature do

    scenario "doctor wrote recomendation, patient read this recommendation", driver: :selenium_chrome, js: true do
        review = FactoryBot.create(:review, review_date: Date.today)
        doctor_user = review.doctor.user
        patient_user = review.user
        FactoryBot.create(:personal_card, user: doctor_user)
        FactoryBot.create(:personal_card, user: patient_user)

        login_as(doctor_user, :scope => :user)
            visit "/reviews"
            within("div#review_#{review.id}") do
                click_link(I18n.t('button.edit_review'))
            end

            expect(page).to have_text(I18n.t('reviews.edit.title'))
            expect(current_path).to eq(edit_review_path(review))
            fill_in_rich_text_area I18n.t('reviews.form.recommendation'), with: "Some doctor_user recommendation."
            click_button I18n.t('button.submit')

            expect(page).to have_text(I18n.t('notice.update.review'))
            expect(current_path).to eq(reviews_path)

            visit "/reviews/#{review.id}/edit"
            expect(page).to have_text(I18n.t('alert.edit.close'))
            expect(current_path).to eq(reviews_path)
        logout(:user)

        login_as(patient_user, :scope => :user)
            visit "/reviews"
            expect(page).not_to have_text("Some doctor_user recommendation.")

            visit "/reviews/medical_card"
            expect(page).to have_text("Some doctor_user recommendation.")
            within("div#review_#{review.id}") do
                click_link(I18n.t('button.show'))
            end
            expect(page).to have_text(I18n.t('reviews.show.title'))
            expect(current_path).to eq(review_path(review))
            expect(page).to have_text("Some doctor_user recommendation.")
    end

end
