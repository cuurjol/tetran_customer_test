FactoryBot.define do
  factory :customer do
    name { Faker::Name.name }
    phone { Faker::PhoneNumber.cell_phone }
    description { Faker::Lorem.paragraph_by_chars }
    blacklist { false }
  end
end