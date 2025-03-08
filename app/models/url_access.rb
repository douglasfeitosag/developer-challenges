class UrlAccess < ApplicationRecord
  belongs_to :shortener_url, counter_cache: true

  before_create do
    self.accessed_at = Time.current
  end
end
