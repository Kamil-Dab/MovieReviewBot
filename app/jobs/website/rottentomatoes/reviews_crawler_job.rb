# frozen_string_literal: true

require "nokogiri"

class Website::Rottentomatoes::ReviewsCrawlerJob < SidekiqJob
  queue_as :default

  def perform(movie_id, end_cursor = nil)
    connect = Website::Rottentomatoes::Crawler.connect()
    crawled_data = Website::CreateCrawledData.call(
      path(movie_id, end_cursor), connect, "get"
    )
    end_cursor, has_next_page = Website::CreateReviewes.call(movie_id, crawled_data.result)

    if has_next_page
      Website::Rottentomatoes::ReviewsCrawlerJob.perform_later(movie_id, end_cursor)
    end
  end

  private
    def path(movie_id, end_cursor)
      if end_cursor
        "/napi/movie/#{movie_id}/reviews/all?after=#{end_cursor.sub('==','')}%3D%3D&pageCount=20"
      else
        "/napi/movie/#{movie_id}/reviews/all"
      end
    end
end
