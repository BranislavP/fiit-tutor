require 'restclient'
require 'nokogiri'

user = User.create!(name:  "Branislav Pecher",
             email: "branop95@gmail.com",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     true,
             activated: true,
             activated_at: Time.zone.now)

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