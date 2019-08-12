class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :name
      t.string :image
      t.text :description
      t.string :isbn
      t.time :published_at
      t.references :author, null: false, foreign_key: true

      t.timestamps
    end
  end
end
