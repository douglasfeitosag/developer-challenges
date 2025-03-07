FactoryBot.define do
  factory :shortener_url do
    original_url { Faker::Internet.url }
    expired_at { nil }
  end
end
