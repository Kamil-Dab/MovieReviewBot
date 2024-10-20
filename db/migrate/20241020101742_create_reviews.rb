class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.string :critic_name, null: false
      t.text :review, null: false
      t.integer :score
      t.date :creation_date, null: false
      t.string :review_url
      t.integer :original_score, null: true
      t.string :score_sentiment, null: false
      t.timestamps
    end
  end
end
