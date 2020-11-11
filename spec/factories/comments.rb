FactoryBot.define do
  factory :comment do
    text  { 'テスト' }
    association :post
    user  { post.user }
  end
end
