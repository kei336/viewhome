FactoryBot.define do
  factory :user do
    name                  { "テストユーザー" }
    email                 { "test@example.com" }
    password              { "password" }
    password_confirmation { "password" }
    activated             { true }

  end
end
