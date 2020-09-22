FactoryBot.define do
  factory :post do
    name { "MyString" }
    content { "MyText" }
    user { nil }
  end
end
