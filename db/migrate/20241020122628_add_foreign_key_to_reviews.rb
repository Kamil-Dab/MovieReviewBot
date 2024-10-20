class AddForeignKeyToReviews < ActiveRecord::Migration[6.1]
  def change
    add_column :reviews, :movie_id, :integer
    add_foreign_key :reviews, :movies
  end
end
