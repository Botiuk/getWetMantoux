require 'rails_helper'

RSpec.feature "Reviews", driver: :selenium_chrome, type: :feature do

    scenario "doctor wrote recomendation, after that cannot edit review, patient read doctor recommendation in medical card", js: true do
        review = FactoryBot.create(:review, review_date: Date.today)
        FactoryBot.create(:personal_card, user: review.doctor.user)
        FactoryBot.create(:personal_card, user: review.user)

        login_as(review.user, :scope => :user)
            visit "/reviews"
            expect(page).to have_selector("div#review_#{review.id}")
            within("div#review_#{review.id}") do
                expect(page).to have_text I18n.t('button.destroy_review')
            end
            visit "/reviews/medical_card"
            expect(page).not_to have_selector("div#review_#{review.id}")
        logout(:user)

        login_as(review.doctor.user, :scope => :user)
            visit "/reviews"
            within("div#review_#{review.id}") do
                click_link I18n.t('button.edit_review')
            end

            expect(page).to have_text I18n.t('reviews.edit.title')
            expect(current_path).to eq(edit_review_path(review))
            fill_in_rich_text_area I18n.t('reviews.form.recommendation'), with: "Some doctor recommendation."
            click_button I18n.t('button.submit')

            expect(page).to have_text I18n.t('notice.update.review')
            expect(current_path).to eq(reviews_path)

            visit "/reviews/#{review.id}/edit"
            expect(page).to have_text I18n.t('alert.edit.close')
            expect(current_path).to eq(reviews_path)

            visit "/reviews"
            expect(page).not_to have_selector("div#review_#{review.id}")
        logout(:user)

        login_as(review.user, :scope => :user)
            visit "/reviews"
            expect(page).not_to have_selector("div#review_#{review.id}")
            expect(page).not_to have_text("Some doctor recommendation.")

            visit "/reviews/medical_card"
            expect(page).to have_selector("div#review_#{review.id}")
            within("div#review_#{review.id}") do
                expect(page).to have_text("Some doctor recommendation.")
                click_link I18n.t('button.show')
            end
            expect(page).to have_text I18n.t('reviews.show.title')
            expect(current_path).to eq(review_path(review))
            expect(page).to have_text("Some doctor recommendation.")
        logout(:user)
    end

    scenario "user makes an appointment through specialities page" do
        doctor = FactoryBot.create(:doctor)
        patient_user = FactoryBot.create(:user)
        FactoryBot.create(:personal_card, user: doctor.user)
        FactoryBot.create(:personal_card, user: patient_user)

        login_as(patient_user, :scope => :user)
            visit "/specialities"
            within("div#speciality_#{doctor.speciality.id}") do
                click_link I18n.t('button.doctors')
            end

            expect(page).to have_text I18n.t('specialities.belonging_doctors.title')
            expect(current_path).to eq(specialities_belonging_doctors_path)
            within("div#doctor_#{doctor.id}") do
                click_link I18n.t('button.add.review')
            end

            expect(page).to have_text I18n.t('reviews.new.title')
            expect(current_path).to eq(new_review_path)
            fill_in I18n.t('reviews.form.review_date'), with: (Date.today + 1)
            click_button I18n.t('button.submit')

            expect(page).to have_text I18n.t('notice.create.review')
            expect(current_path).to eq(reviews_path)
        logout(:user)
    end

    scenario "user makes an appointment through doctors page" do
        doctor = FactoryBot.create(:doctor)
        patient_user = FactoryBot.create(:user)
        FactoryBot.create(:personal_card, user: doctor.user)
        FactoryBot.create(:personal_card, user: patient_user)

        login_as(patient_user, :scope => :user)
            visit "/doctors"
            within("div#doctor_#{doctor.id}") do
                click_link I18n.t('button.add.review')
            end

            expect(page).to have_text I18n.t('reviews.new.title')
            expect(current_path).to eq(new_review_path)
            fill_in I18n.t('reviews.form.review_date'), with: (Date.today + 2)
            click_button I18n.t('button.submit')

            expect(page).to have_text I18n.t('notice.create.review')
            expect(current_path).to eq(reviews_path)
        logout(:user)
    end

    scenario "user cannot make an appointment with the same doctor" do
        doctor = FactoryBot.create(:doctor)
        patient_user = FactoryBot.create(:user)
        FactoryBot.create(:personal_card, user: doctor.user)
        FactoryBot.create(:personal_card, user: patient_user)
        FactoryBot.create(:review, user: patient_user, doctor: doctor)

        login_as(patient_user, :scope => :user)
            visit "/doctors"
            within("div#doctor_#{doctor.id}") do
                click_link I18n.t('button.add.review')
            end

            expect(page).to have_text I18n.t('alert.new.present')
            expect(current_path).to eq(reviews_path)
        logout(:user)
    end

    scenario "user cannot make an appointment with a doctor who has 10 appointments without a recommendation on the same date, but can in other date" do
        doctor = FactoryBot.create(:doctor)
        patient_user = FactoryBot.create(:user)
        FactoryBot.create(:personal_card, user: doctor.user)
        FactoryBot.create(:personal_card, user: patient_user)
        10.times do
            FactoryBot.create(:review, review_date: (Date.today + 3), doctor: doctor )
        end

        login_as(patient_user, :scope => :user)
            visit "/doctors"
            within("div#doctor_#{doctor.id}") do
                click_link I18n.t('button.add.review')
            end

            expect(page).to have_text I18n.t('reviews.new.title')
            expect(current_path).to eq(new_review_path)
            fill_in I18n.t('reviews.form.review_date'), with: (Date.today + 3)
            click_button I18n.t('button.submit')

            expect(page).to have_text I18n.t('alert.doctor_busy')
            expect(current_path).to eq(new_review_path)

            visit "/doctors"
            within("div#doctor_#{doctor.id}") do
                click_link I18n.t('button.add.review')
            end

            expect(page).to have_text I18n.t('reviews.new.title')
            expect(current_path).to eq(new_review_path)
            fill_in I18n.t('reviews.form.review_date'), with: (Date.today + 1)
            click_button I18n.t('button.submit')

            expect(page).to have_text I18n.t('notice.create.review')
            expect(current_path).to eq(reviews_path)
        logout(:user)
    end

    scenario "user can cancel an appointment before doctor's review" do
        doctor = FactoryBot.create(:doctor)
        patient_user = FactoryBot.create(:user)
        FactoryBot.create(:personal_card, user: doctor.user)
        FactoryBot.create(:personal_card, user: patient_user)
        review = FactoryBot.create(:review, user: patient_user, doctor: doctor)

        login_as(patient_user, :scope => :user)
            visit "/reviews"
            within("div#review_#{review.id}") do
                accept_alert do
                    click_button I18n.t('button.destroy_review')
                end
            end

            expect(page).to have_text I18n.t('notice.destroy.review')
            expect(current_path).to eq(reviews_path)
            expect(page).not_to have_selector("div#review_#{review.id}")
        logout(:user)
    end

    scenario "admin created his appointment and after that on the reviews page appears collapsed accordion block" do
        doctor = FactoryBot.create(:doctor)
        admin_user = FactoryBot.create(:user, role: "admin")
        FactoryBot.create(:personal_card, user: doctor.user)
        FactoryBot.create(:personal_card, user: admin_user)

        login_as(admin_user, :scope => :user)
            visit "/reviews"
            expect(page).not_to have_selector("div#accordionExample")
            expect(page).not_to have_text I18n.t('reviews.index.my_reviews')

            visit "/doctors"
            within("div#doctor_#{doctor.id}") do
                click_link I18n.t('button.add.review')
            end

            expect(page).to have_text I18n.t('reviews.new.title')
            expect(current_path).to eq(new_review_path)
            fill_in I18n.t('reviews.form.review_date'), with: (Date.today)
            click_button I18n.t('button.submit')

            expect(page).to have_text I18n.t('notice.create.review')
            expect(current_path).to eq(reviews_path)
            expect(page).to have_selector("div#accordionExample")
            within("div#accordionExample") do
                expect(page).to have_text I18n.t('reviews.index.my_reviews')
            end
        logout(:user)
    end

    scenario "doctor created his appointment to other doctor and after that on the reviews page appears collapsed accordion block" do
        doctor = FactoryBot.create(:doctor)
        doctor_two = FactoryBot.create(:doctor)
        FactoryBot.create(:personal_card, user: doctor.user)
        FactoryBot.create(:personal_card, user: doctor_two.user)

        login_as(doctor.user, :scope => :user)
            visit "/reviews"
            expect(page).not_to have_selector("div#accordionExample")
            expect(page).not_to have_text I18n.t('reviews.index.my_reviews')

            visit "/doctors"
            within("div#doctor_#{doctor_two.id}") do
                click_link I18n.t('button.add.review')
            end

            expect(page).to have_text I18n.t('reviews.new.title')
            expect(current_path).to eq(new_review_path)
            fill_in I18n.t('reviews.form.review_date'), with: (Date.today)
            click_button I18n.t('button.submit')

            expect(page).to have_text I18n.t('notice.create.review')
            expect(current_path).to eq(reviews_path)
            expect(page).to have_selector("div#accordionExample")
            within("div#accordionExample") do
                expect(page).to have_text I18n.t('reviews.index.my_reviews')
            end
        logout(:user)
    end

    scenario "doctor cannot create an appointment with themself" do
        doctor = FactoryBot.create(:doctor)
        FactoryBot.create(:personal_card, user: doctor.user)

        login_as(doctor.user, :scope => :user)
            visit "/doctors"
            within("div#doctor_#{doctor.id}") do
                expect(page).not_to have_text I18n.t('button.add.review')
                expect(page).to have_text I18n.t('button.edit')
            end

            visit "/reviews/new?doctor_id=#{doctor.id}"
            expect(page).to have_text I18n.t('alert.new.recursion')
            expect(current_path).to eq(specialities_path)
        logout(:user)
    end

    scenario "doctor can read medical card of patient in new window during review", js: true do
        review = FactoryBot.create(:review, review_date: Date.today)
        review_two = FactoryBot.create(:review, review_date: Date.today, user: review.user)
        FactoryBot.create(:personal_card, user: review.doctor.user)
        FactoryBot.create(:personal_card, user: review.user)
        FactoryBot.create(:personal_card, user: review_two.doctor.user)

        login_as(review.doctor.user, :scope => :user)
            visit "/reviews"
            within("div#review_#{review.id}") do
                click_link I18n.t('button.edit_review')
            end
            expect(page).to have_text I18n.t('reviews.edit.title')
            expect(current_path).to eq(edit_review_path(review))
            new_window = window_opened_by { click_link I18n.t('button.medical_card')}
            within_window new_window do
                expect(current_path).to eq(reviews_medical_card_path)
                expect(page).to have_text I18n.t('reviews.medical_card.reviews_empty')
            end
            fill_in_rich_text_area I18n.t('reviews.form.recommendation'), with: "Some doctor recommendation."
            click_button I18n.t('button.submit')

            expect(page).to have_text I18n.t('notice.update.review')
            expect(current_path).to eq(reviews_path)
        logout(:user)

        login_as(review_two.doctor.user, :scope => :user)
            visit "/reviews"
            within("div#review_#{review_two.id}") do
                click_link I18n.t('button.edit_review')
            end

            expect(page).to have_text I18n.t('reviews.edit.title')
            expect(current_path).to eq(edit_review_path(review_two))
            new_window_two = window_opened_by { click_link I18n.t('button.medical_card')}
            within_window new_window_two do
                expect(current_path).to eq(reviews_medical_card_path)
                within("div#review_#{review.id}") do
                    expect(page).to have_text 'Some doctor recommendation.'
                    click_link I18n.t('button.show')
                end
                expect(page).to have_text I18n.t('reviews.show.title')
                expect(current_path).to eq(review_path(review))
                expect(page).to have_text("Some doctor recommendation.")
            end
        logout(:user)
    end

    scenario "admin, doctor, and user check the available buttons in reviews_path, depending on their role and review_date" do
        doctor = FactoryBot.create(:doctor)
        patient_user = FactoryBot.create(:user)
        admin_user = FactoryBot.create(:user, role: "admin")
        FactoryBot.create(:personal_card, user: doctor.user)
        FactoryBot.create(:personal_card, user: patient_user)
        FactoryBot.create(:personal_card, user: admin_user)
        review = FactoryBot.create(:review, review_date: Date.today, user: patient_user, doctor: doctor)
        review_two = FactoryBot.create(:review, review_date: (Date.today + 1), user: admin_user, doctor: doctor)

        login_as(doctor.user, :scope => :user)
            visit "/reviews"
            expect(page).not_to have_selector("div#accordionExample")
            expect(page).to have_selector("div#review_#{review.id}")
            within("div#review_#{review.id}") do
                expect(page).not_to have_text I18n.t('button.destroy_review')
                expect(page).to have_text I18n.t('button.edit_review')
            end
            expect(page).to have_selector("div#review_#{review_two.id}")
            within("div#review_#{review_two.id}") do
                expect(page).not_to have_text I18n.t('button.destroy_review')
                expect(page).not_to have_text I18n.t('button.edit_review')
            end
        logout(:user)

        login_as(patient_user, :scope => :user)
            visit "/reviews"
            expect(page).to have_selector("div#review_#{review.id}")
            within("div#review_#{review.id}") do
                expect(page).to have_text I18n.t('button.destroy_review')
                expect(page).not_to have_text I18n.t('button.edit_review')
            end
        logout(:user)

        login_as(admin_user, :scope => :user)
            visit "/reviews"
            expect(page).to have_selector("div#review_#{review.id}")
            within("div#review_#{review.id}") do
                expect(page).not_to have_text I18n.t('button.destroy_review')
                expect(page).not_to have_text I18n.t('button.edit_review')
            end
            expect(page).to have_selector("div#review_#{review_two.id}")
            within("div#review_#{review_two.id}") do
                expect(page).to have_text I18n.t('button.destroy_review')
                expect(page).not_to have_text I18n.t('button.edit_review')
            end
            expect(page).to have_selector("div#accordionExample")
            within("div#accordionExample") do
                expect(page).to have_text I18n.t('reviews.index.my_reviews')
                expect(page).not_to have_selector("div#review_#{review_two.id}")
                click_button I18n.t('reviews.index.my_reviews')
            end
            within("div#accordionExample") do
                expect(page).to have_selector("div#review_#{review_two.id}")
                within("div#review_#{review_two.id}") do
                    expect(page).to have_text I18n.t('button.destroy_review')
                    expect(page).not_to have_text I18n.t('button.edit_review')
                end
            end
        logout(:user)
    end

end
