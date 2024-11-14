# getWetMantoux

App for managing the medical clinic. An appointment with a doctor, a doctor's examination, and a user's medical card.

Built with: Rails 7.2.1.2, Ruby 3.3.5, postgres, Turbo, Stimulus, Bootstrap, Trix editor, Cloudinary, devise, cancancan.

Test with: RSpec, Capybara, factory_bot_rails and faker.

Code style checking: RuboCop and his special cops.

Deployed on: https://getwetmantoux.onrender.com/ (free instance will spin down with inactivity, which can delay requests by 50 seconds or more).

My native language is Ukrainian and this is a single language on app. But all interface text was made with I18n and easy to change with translating locale file.

"Get wet Mantoux!" - is the unofficial slogan of Ukrainian doctors, who fight with beliefs and myths about treatment and promote evidence-based medicine.

In this app, registered users can have one of three roles: user, doctor, or admin. By default, after registration, all have user roles. Admin can change the role of a user. The first admin must be created through seeds. Doctors and admins also can be clients of the clinic and that's why they can visit doctors and have a personal medical card, the same as a user with a user role.

Unregistered users can see the welcome page and clinic contacts and look at which doctors work in the clinic. After registration with the phone number, each user must fill personal card. After that, the user can make an appointment with a doctor and choose the date of the visit. If the doctor has many patients on this date, an appointment will not be created and to user will send a proposal to choose another date. Users can cancel appointments before the doctor's review. After the doctor's review, a record of the appointment is moved to the user's medical card, where he can read the recommendation. The user can change his phone number and password, but cannot delete the profile.

Administrators can create medical specialties and doctors' business cards for users with the role "doctor", and edit users and their personal cards. On a doctor's business card, he must choose a specialty and doctor status. Also, administrators can add a personal photo and doctor biography. Other information is taken from users' personal cards. If a doctor's status is "fired" he automatically receives only user opportunities and disappears from the doctors' list available for appointment. Business cards cannot be deleted because they have references in medical card records.

Doctors can examine patients who are scheduled for an appointment today. During the examination, review the medical record of the current patient (opens in a new window) to assess his health changes and read the recommendations of other specialists. After filling in the recommendations the doctor's review is considered complete, and the record is added to the patient medical card and cannot be edited. Also, the doctor can change the photo and biography on his personal business card.