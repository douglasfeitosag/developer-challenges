# spec/requests/shortener_urls_spec.rb
require 'rails_helper'

RSpec.describe 'ShortenerUrlsController', type: :request do
  describe 'POST /api/shortener_urls' do
    context 'with valid parameters' do
      it 'creates a shortened URL' do
        valid_params = { shortener_url: { original_url: 'https://vuejs.org/guide/quick-start.html' } }

        expect {
          post '/api/shortener_urls', params: valid_params, as: :json
        }.to change(ShortenerUrl, :count).by(1)

        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body)
        expect(json.keys).to contain_exactly('created_at', 'expired_at', 'id', 'original_url', 'short_url', 'updated_at', 'url_accesses_count')
        expect(json['original_url']).to eq('https://vuejs.org/guide/quick-start.html')
        expect(json['url_accesses_count']).to eq(0)
        expect(json['expired_at']).to be_nil
      end
    end

    context 'with invalid parameters' do
      it 'creates a shortened URL' do
        valid_params = { shortener_url: { original_url: '' } }

        expect {
          post '/api/shortener_urls', params: valid_params, as: :json
        }.to change(ShortenerUrl, :count).by(0)

        expect(response).to have_http_status(:unprocessable_entity)

        json = JSON.parse(response.body)
        expect(json.keys).to contain_exactly('original_url')
        expect(json['original_url']).to eq( ["can't be blank"])
      end
    end
  end

  describe 'GET /api/shortener_urls/:id' do
    context 'when the shortened URL exists' do
      it 'retrieves the shortened URL by ID' do
        short_url = ShortenerUrl.create!(original_url: 'https://vuejs.org/guide/quick-start.html')

        get "/api/shortener_urls/#{short_url.id}"

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json.keys).to contain_exactly('created_at', 'expired_at', 'id', 'original_url', 'short_url', 'updated_at', 'url_accesses', 'url_accesses_count')
        expect(json['id']).to eq(short_url.id)
        expect(json['original_url']).to eq('https://vuejs.org/guide/quick-start.html')
        expect(json['short_url']).to eq(short_url.short_url)
        expect(json['url_accesses_count']).to eq(short_url.url_accesses_count)
        expect(json['expired_at']).to eq(short_url.expired_at)
        expect(json['created_at']).to eq(short_url.created_at.as_json)
        expect(json['updated_at']).to eq(short_url.updated_at.as_json)
      end
    end

    context 'when the shortened URL does not exist' do
      it 'returns not_found' do
        get '/api/shortener_urls/999999'

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
