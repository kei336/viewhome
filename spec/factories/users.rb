FactoryBot.define do
  factory :user do
    name                  { Faker::Name.name }
    email                 { Faker::Internet.email }
    password              { "password" }
    password_confirmation { "password" }
    activated             { true }
  end
  factory :other_user, class: User do
    name                  { "otheruser" }
    email                 { Faker::Internet.email }
    password              { "password" }
    password_confirmation { "password" }
    activated             { true }
  end
  factory :guest_user, class: User do
    name                  { "guestuser" }
    email                 { Faker::Internet.email }
    password              { "password" }
    password_confirmation { "password" }
    activated             { true }
  end
end
