require 'json'

class Website::CreateReviewes
  def self.call(movie_id, result)
    new(movie_id, result).upsert_all_reviewes()
  end

  def initialize(movie_id, result)
    @movie_id = movie_id
    @result = result
  end

  attr_reader :result, :movie_id

  def upsert_all_reviewes
    data = format_crawled_data()
    return if data.empty?

    Review.upsert_all(
      data,
      unique_by: [:critic_name, :movie_id],
    )
  end

  def format_crawled_data
    reviews = JSON.parse(result)['reviews']
    return [] if reviews.blank?

    reviews.map do |review|
      {
        critic_name: review['criticName'],
        review: review['quote'],
        creation_date: review['creationDate'],
        review_url: review['reviewUrl'],
        original_score: review['originalScore'],
        score_sentiment: review['scoreSentiment'],
        movie_id: Movie.find_by(movie_id: movie_id).id
      }.merge(created_at: Time.current, updated_at: Time.current)
    end
  end
end
