module API
  class UrlAccessesController < ApplicationController
    def visit
      @shortener_url = ShortenerUrl.find_by!(short_url_param) rescue (head :not_found and return)

      head :not_found and return if @shortener_url.expired?

      head :unprocessable_entity and return unless UrlAccess.create(shortener_url: @shortener_url)

      redirect_to @shortener_url.original_url, allow_other_host: true
    end

    def short_url_param
      params.permit(:short_url)
    end
  end
end
