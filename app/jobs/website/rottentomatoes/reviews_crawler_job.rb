# frozen_string_literal: true

require "nokogiri"

class Website::Rottentomatoes::ReviewsCrawlerJob < SidekiqJob
  queue_as :default

  def perform(movie_id)
    puts "Crawling reviews for movie_id: #{movie_id}"
    connect = Website::Rottentomatoes::Crawler.connect()
    crawled_data = Website::CreateCrawledData.call(
      path(movie_id), connect, "get"
    )
    Website::CreateReviewes.call(movie_id, crawled_data.result)
  end

  private
    def path(movie_id)
      "/napi/movie/#{movie_id}/reviews/all"
    end
end
