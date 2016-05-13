require 'restclient'
require 'nokogiri'

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

REQUEST_URL = "is.stuba.sk/katalog/index.pl"

lang = 'sk'
ustav = 0
vypsat = 'Vyp%EDsa%BB+predmety'
fakulta = 21070
obdobi = 201
jak = 'dle_pracovist'
subject = Array.new
if page = RestClient.post(REQUEST_URL, {'lang'=>lang,'ustav'=>ustav,'vypsat'=>vypsat,
                                        'fakulta'=>fakulta,'obdobi'=>obdobi,'jak'=>jak})
  npage = Nokogiri::HTML(page)
  rows = npage.css('a')
  rows.each do |row|
    pom = row.text
    if !pom.match(/^[A-Z]{2}.+/).nil? && pom.match(/^(DP[0-9]|BP[0-9]|OP|PC|PSPE|TK|SP_|VYBER|VP|ZP_|ZS_|OBHAJ).+/).nil?
      subject << row.text
    end
  end
end
Subject.create(acronym: "Generic", name: "Generický predmet pre tie čo nie sú v zozname", level: 0)
subject.each do |subj|
  acronym = subj.match(/^[A-Z]+/).to_s
  level = (subj.match(/(B|I) /).to_s.match("B")? 0:1)
  name = subj.match(/ .+$/).to_s.slice((1..subj.length))
  Subject.create(acronym: acronym, name: name, level: level)
end