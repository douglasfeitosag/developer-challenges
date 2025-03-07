FactoryBot.define do
  factory :url_access do
    shortener_url
    accessed_at { Time.now }
  end
end
