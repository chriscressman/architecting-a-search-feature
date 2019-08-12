class ChangePublishedAtToDate < ActiveRecord::Migration[6.0]
  def up
    change_column :books, :published_at, :date
  end

  def down
    change_column :books, :published_at, :time
  end
end
