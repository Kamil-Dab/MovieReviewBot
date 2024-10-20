class AddMovieIdToMovies < ActiveRecord::Migration[6.1]
  def change
    add_column :movies, :movie_id, :string
    add_index :movies, :movie_id, unique: true
  end
end
