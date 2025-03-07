class CreateUrlAccesses < ActiveRecord::Migration[8.0]
  def change
    create_table :url_accesses do |t|
      t.references :shortener_url, null: false, foreign_key: true
      t.datetime :accessed_at, null: false

      t.timestamps
    end
  end
end
