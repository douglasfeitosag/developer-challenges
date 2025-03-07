class UrlAccess < ApplicationRecord
  belongs_to :shortener_url, counter_cache: true

  validates :accessed_at, presence: true
end
