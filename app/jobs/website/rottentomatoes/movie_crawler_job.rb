# frozen_string_literal: true

class Website::Rottentomatoes::MovieCrawlerJob < SidekiqJob
  queue_as :default

  def perform(path)
    connect = Website::Rottentomatoes::Crawler.connect()
    crawled_data = Website::CreateCrawledData.call(
      path, connect, "get"
    )

    movie = Website::CreateMovie.call(
      crawled_data.result
    )
    Website::Rottentomatoes::ReviewsCrawlerJob.perform_later(movie.pluck("movie_id").first)
  end
end
