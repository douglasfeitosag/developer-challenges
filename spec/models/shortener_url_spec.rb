require 'rails_helper'

RSpec.describe ShortenerUrl, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:original_url) }
    it { should validate_uniqueness_of(:short_url) }
  end

  describe 'associations' do
    it { should have_many(:url_accesses).dependent(:destroy) }
  end

  describe 'callbacks' do
    it 'generates a unique short_url before creation' do
      url1 = create(:shortener_url)
      url2 = create(:shortener_url)

      expect(url1.short_url).to be_present
      expect(url2.short_url).to be_present
      expect(url1.short_url).not_to eq(url2.short_url)
    end

    it 'ensures short_url length is between 5 and 10 characters' do
      url = create(:shortener_url)
      expect(url.short_url.length).to be_between(5, 10)
    end
  end

  describe 'uniqueness' do
    it 'does not allow duplicate short URLs' do
      url1 = create(:shortener_url)
      url2 = build(:shortener_url, short_url: url1.short_url)

      expect(url2.valid?).to be_falsey
      expect(url2.errors[:short_url]).to include('has already been taken')
    end
  end

  describe 'expiration logic' do
    let(:valid_url) { create(:shortener_url, expired_at: 1.day.from_now) }
    let(:expired_url) { create(:shortener_url, expired_at: 1.day.ago) }

    it 'allows access if expired_at is nil' do
      url = create(:shortener_url, expired_at: nil)
      expect(url.expired?).to be_falsey
    end

    it 'allows access if expired_at is in the future' do
      expect(valid_url.expired?).to be_falsey
    end

    it 'denies access if expired_at is in the past' do
      expect(expired_url.expired?).to be_truthy
    end
  end

  describe 'url accesses count' do
    let(:shortener_url) { create(:shortener_url) }

    it 'changes url_accesses_count when create log' do
      expect(shortener_url.url_accesses_count).to eq(0)

      create(:url_access, shortener_url: shortener_url)

      expect(shortener_url.url_accesses_count).to eq(1)
    end

    it 'destroys associated url_accesses when deleted' do
      create(:url_access, shortener_url: shortener_url)
      create(:url_access, shortener_url: shortener_url)

      expect {
        shortener_url.destroy
      }.to change(UrlAccess, :count).to eq(0)
    end
  end
end
