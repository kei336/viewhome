FactoryBot.define do
  factory :post do
    user
    name            { 'テスト' }
    content         { 'テスト' }
    trait :post_image do
      image {
        fixture_file_upload("app/assets/images/IMG_7226.PNG")
      }
    end
  end
end
