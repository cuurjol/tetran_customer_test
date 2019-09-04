10.times do
  Customer.create(name: Faker::Name.name, phone: Faker::PhoneNumber.cell_phone,
                  description: Faker::Lorem.paragraph_by_chars)
end