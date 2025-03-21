class ShortenerUrl < ApplicationRecord
  validates :original_url, presence: true
  validates :short_url, uniqueness: true
  validates :expired_at, allow_nil: true, comparison: { greater_than: -> { Time.current } }

  has_many :url_accesses, dependent: :destroy

  before_create do
    self.url_accesses_count = 0
  end
  before_create :generate_short_url

  def expired?
    expired_at.present? && expired_at < Time.current
  end

  private

  def generate_short_url
    self.short_url = loop do
      random_code = SecureRandom.alphanumeric(rand(5..10))
      break random_code unless ShortenerUrl.exists?(short_url: random_code)
    end
  end
end
