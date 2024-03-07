require "faker"

User.create(
    id: 1,
    phone: "0971837132",
    password: ENV['SEEDS_PASS'],
    password_confirmation: ENV['SEEDS_PASS'],
    role: 2
)

User.create(
    id: 2,
    phone: "1234567890",
    password: ENV['SEEDS_PASS'],
    password_confirmation: ENV['SEEDS_PASS'],
    role: 0
)

User.create(
    id: 3,
    phone: "0987654321",
    password: ENV['SEEDS_PASS'],
    password_confirmation: ENV['SEEDS_PASS'],
    role: 1
)

(4..15).each do |id|
    password = Faker::Internet.password(min_length: 6)
    User.create(
        id: id,
        phone: Faker::Number.unique.number(digits: 8),
        password: password,
        password_confirmation: password,
        role: 1
    )
end

(16..100).each do |id|
    password = Faker::Internet.password(min_length: 6)
    User.create(
        id: id,
        phone: Faker::Number.unique.number(digits: 9),
        password: password,
        password_confirmation: password,
        role: 0
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

(3..15).each do |user_id|
    Doctor.create(
        user_id: user_id,
        speciality_id: rand(1..10),
        doctor_status: 0
    )
end

Doctor.all.each do |doctor|
    ActionText::RichText.create!(
        record_type: 'Doctor',
        record_id: doctor.id,
        name: 'doctor_info',
        body: Faker::Lorem.paragraph
    )
end

300.times do
    Review.create(
        doctor_id: rand(1..13),
        user_id: rand(1..100),
        review_date: Faker::Date.between(from: 20.days.ago, to: Date.today)
    )
end

Review.all.each do |review|
    ActionText::RichText.create!(
        record_type: 'Review',
        record_id: review.id,
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