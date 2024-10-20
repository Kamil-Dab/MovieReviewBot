class AddUniqueIndexToReviews < ActiveRecord::Migration[6.1]
  def change
    add_index :reviews, [:critic_name, :movie_id], unique: true, name: 'index_reviews_on_critic_name_and_movie_id'
  end
end
