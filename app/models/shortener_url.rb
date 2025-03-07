class ShortenerUrl < ApplicationRecord
  validates :original_url, presence: true
  validates :short_url, uniqueness: true

  before_create :generate_short_url

  private

  def generate_short_url
    self.short_url = loop do
      random_code = SecureRandom.alphanumeric(rand(5..10))
      break random_code unless ShortenerUrl.exists?(short_url: random_code)
    end
  end
end
