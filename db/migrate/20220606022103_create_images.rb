class CreateImages < ActiveRecord::Migration[7.0]
  def change
    create_table :images do |t|
      t.string :url, null: false
      t.string :mime_type
      t.timestamps
      t.index :url, unique: true
      t.index :mime_type # For quickly selecting not-yet-processed images
    end
  end
end
