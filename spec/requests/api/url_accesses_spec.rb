require 'rails_helper'

RSpec.describe 'UrlAccessesController', type: :request do
  describe 'GET /api/url_accesses/visit' do
    let(:shortener_url) { create(:shortener_url, original_url: 'https://vuejs.org/guide/quick-start.html') }
    let(:expired_shortener_url) { create(:shortener_url, original_url: 'https://vuejs.org/guide/install.html', expired_at: 1.day.ago) }

    context 'when the short URL exists and is not expired' do
      it 'redirects to the original URL' do
        get "/#{shortener_url.short_url}"

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(shortener_url.original_url)
      end
    end

    context 'when the short URL does not exist' do
      it 'returns not_found' do
        get '/api/url_accesses/visit', params: { short_url: 'invalid' }

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the short URL is expired' do
      it 'returns not_found' do
        get '/api/url_accesses/visit', params: { short_url: expired_shortener_url.short_url }

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the URL access creation fails' do
      before do
        allow(UrlAccess).to receive(:create).and_return(false)
      end

      it 'returns internal_server_error' do
        get "/#{shortener_url.short_url}"

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
