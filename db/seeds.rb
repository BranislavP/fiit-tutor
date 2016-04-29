user = User.create!(name:  "Branislav Pecher",
             email: "branop95@gmail.com",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

users = User.order(:created_at).take(8)
5.times do
  users.each { |user| subject = ["DSA", "AZA", "DBS", "UI", "VOS", "OOP"].sample
  name = Faker::Lorem.sentence(5) + subject
  description = Faker::Lorem.sentence(25)
  place = "FIIT"
  cost = (1..19).to_a.sample
  user.events.create!(name: name, subject:subject, description: description, place: place, cost: cost, date: Time.zone.tomorrow) }
end

user.events.create!(name: "Uplne mega event o DBS", subject: "DBS", description: "Budeme riesit DBS", place: "FIIT STU", cost: 5, date: Time.zone.now)

users = User.order(:created_at).take(50)
100.times do
  users.each { |user| subject = ["DSA", "AZA", "DBS", "UI", "VOS", "OOP"].sample
  name = Faker::Lorem.sentence(5) + subject
  description = Faker::Lorem.sentence(25)
  place = "FIIT"
  cost = (1..19).to_a.sample
  user.events.create!(name: name, subject:subject, description: description, place: place, cost: cost, date: Time.zone.tomorrow) }
end

user1 = User.first
user2 = User.find(2)
test_event = user2.events.create!(name: "Testovaci event", subject: "VOS", description: "Only for testing", place: "FIIT", cost: 8, date: Time.zone.tomorrow)
user1.event_users.create!(event_id: test_event.id)
finished_event = user2.events.create!(name: "Vcerajsi", subject: "VOS", description: "Uz bol", place: "FIIT", cost: 8, date: Time.zone.now)
user1.event_users.create!(event_id: finished_event.id)