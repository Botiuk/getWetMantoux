require "faker"

case Rails.env
when "development"

    User.create(
        phone: "0971837132",
        password: ENV['SEEDS_PASS'],
        password_confirmation: ENV['SEEDS_PASS'],
        role: "admin"
    )

    User.create(
        phone: "1234567890",
        password: ENV['SEEDS_PASS'],
        password_confirmation: ENV['SEEDS_PASS'],
        role: "doctor"
    )

    User.create(
        phone: "0987654321",
        password: ENV['SEEDS_PASS'],
        password_confirmation: ENV['SEEDS_PASS']
    )

    12.times do
        password = Faker::Internet.password(min_length: 6)
        User.create(
            phone: Faker::Number.unique.number(digits: 8),
            password: password,
            password_confirmation: password,
            role: "doctor"
        )
    end

    85.times do
        password = Faker::Internet.password(min_length: 6)
        User.create(
            phone: Faker::Number.unique.number(digits: 9),
            password: password,
            password_confirmation: password
        )
    end

    (1..100).each do |user_id|
        PersonalCard.create(
            user_id: user_id,
            last_name: Faker::Name.last_name,
            first_name: Faker::Name.first_name,
            date_of_birth: Faker::Date.between(from: 100.year.ago, to: Date.today)
        )
    end

    10.times do
        Speciality.create(
            name: Faker::Job.unique.field,
            description: Faker::Movies::StarWars.wookiee_sentence
        )
    end

    doctor_user_id = User.where(role: "doctor").pluck(:id)
    doctor_user_id.each do |user_id|
        Doctor.create(
            user_id: user_id,
            speciality_id: rand(1..10),
            doctor_status: 0
        )
    end

    doctor_id = Doctor.pluck(:id)
        ActiveStorage::Blob.create!(
            key: 'pbcj80wo1ggewlfs6zfrjqhg93va',
            filename: 'doctor_empty_photo.jpg',
            content_type: 'image/jpeg',
            metadata: '{"identified":true,"width":380,"height":380,"analyzed":true}',
            service_name: 'cloudinary',
            byte_size: 5704,
            checksum: 'Yp8xTVxnrsK16TZ6wJaPbw=='
        )
    doctor_id.each do |record_id|
        ActionText::RichText.create!(
            record_type: 'Doctor',
            record_id: record_id,
            name: 'doctor_info',
            body: Faker::Lorem.paragraph
        )
        ActiveStorage::Attachment.create!(
            record_type: 'Doctor',
            record_id: record_id,
            name: 'doctor_photo',
            blob_id: 1
        )
    end

    300.times do
        Review.create(
            doctor_id: rand(1..13),
            user_id: rand(1..100),
            review_date: Faker::Date.between(from: 20.days.ago, to: Date.today)
        )
    end

    review_id = Review.pluck(:id)
    review_id.each do |record_id|
        ActionText::RichText.create!(
            record_type: 'Review',
            record_id: record_id,
            name: 'recommendation',
            body: Faker::Lorem.paragraph_by_chars
        )
    end

    200.times do
        Review.create(
            doctor_id: rand(1..13),
            user_id: rand(1..100),
            review_date: Faker::Date.between(from: Date.today, to: 7.days.from_now)
        )
    end

when "production"

    user = User.where(phone: "0971837132").first_or_initialize
    user.update!(
        password: ENV['SEEDS_PASS'],
        password_confirmation: ENV['SEEDS_PASS'],
        role: "admin"
    )

end