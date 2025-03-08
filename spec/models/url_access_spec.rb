require 'rails_helper'

RSpec.describe UrlAccess, type: :model do
  describe 'associations' do
    it { should belong_to(:shortener_url).counter_cache(true) }
  end

  describe 'callbacks' do
    context 'before_create' do
      it 'creates with accessed_at' do
        url_access = build(:url_access)

        expect(url_access.accessed_at).to be_nil
        expect(url_access.save).to be_truthy
        expect(url_access.accessed_at).not_to be_nil
      end
    end
  end
end
