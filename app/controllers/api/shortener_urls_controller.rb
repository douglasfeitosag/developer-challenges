module API
  class ShortenerUrlsController < ActionController::API
    def show
      @shortener_url = ShortenerUrl.find(params[:id]) rescue (head :not_found and return)

      render json: @shortener_url.serializable_hash(include: { url_accesses: { only: :accessed_at } })
    end

    def create
      @shortener_url = ShortenerUrl.new(shortener_url_params)

      if @shortener_url.save
        render json: @shortener_url.serializable_hash, status: 201
      else
        head :unprocessable_entity
      end
    end

    private

    def shortener_url_params
      params.require(:shortener_url).permit(:original_url, :expired_at)
    end
  end
end
