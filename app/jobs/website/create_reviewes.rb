# frozen_string_literal: true

require "json"

class Website::CreateReviewes
  def self.call(movie_id, result)
    instance = new(movie_id, result)
    instance.upsert_all_reviewes

    [instance.end_cursor, instance.has_next_page]
    end

  def initialize(movie_id, result)
    @movie_id = movie_id
    @result = JSON.parse(result)
    @end_cursor = @result.dig("pageInfo", "endCursor")
    @has_next_page = @result.dig("pageInfo", "hasNextPage")
  end

  attr_reader :result, :movie_id, :end_cursor, :has_next_page

  def upsert_all_reviewes
    data = format_crawled_data()
    return if data.empty?

    Review.upsert_all(
      data,
      unique_by: [:critic_name, :movie_id],
    )
  end

  def format_crawled_data
    reviews = result["reviews"]
    return [] if reviews.blank?

    reviews.map do |review|
      next if review["criticName"].blank?

      {
      critic_name: review["criticName"],
      review: review["quote"],
      creation_date: review["creationDate"],
      review_url: review["reviewUrl"],
      original_score: review["originalScore"],
      score_sentiment: review["scoreSentiment"],
      movie_id: Movie.find_by(movie_id: movie_id).id
      }.merge(created_at: Time.current, updated_at: Time.current)
    end.compact
  end
end
