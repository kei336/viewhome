FactoryBot.define do
  factory :user do
    name            { "テストユーザー" }
    email           { "test1@example.cpm" }
    password        { "password" }
    password_digest { "password" }
  end
end
