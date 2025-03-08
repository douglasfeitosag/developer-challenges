class CreateShortenerUrls < ActiveRecord::Migration[8.0]
  def change
    create_table :shortener_urls do |t|
      t.string :original_url, null: false
      t.string :short_url, null: false
      t.integer :url_accesses_count, null: false
      t.datetime :expired_at

      t.timestamps
    end

    add_index :shortener_urls, :short_url, unique: true
  end
end
