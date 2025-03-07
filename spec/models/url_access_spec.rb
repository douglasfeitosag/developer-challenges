require 'rails_helper'

RSpec.describe UrlAccess, type: :model do
  describe 'associations' do
    it { should belong_to(:shortener_url).counter_cache(true) }
  end

  describe 'validations' do
    it { should validate_presence_of(:accessed_at) }
  end
end