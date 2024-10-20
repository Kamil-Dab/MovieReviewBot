# frozen_string_literal: true

class Website::Rottentomatoes::ListMoviesCrawlerJob < SidekiqJob
  queue_as :default

  def perform(end_cursor = nil)
    connect = Website::Rottentomatoes::Crawler.connect()
    crawled_data = Website::CreateCrawledData.call(
      path(end_cursor), connect, "get"
    )

    parse_result(crawled_data.result).each do |movie_url|
      Website::Rottentomatoes::MovieCrawlerJob.perform_later(movie_url)
    end

    check_next_page(crawled_data.result).tap do |end_cursor, has_next_page|
      if has_next_page
        Website::Rottentomatoes::ListMoviesCrawlerJob.perform_later(end_cursor)
      end
    end
  end

  private
    def path(end_cursor)
      if end_cursor
        "/napi/browse/movies_at_home?after=#{end_cursor.sub('=','')}%3D"
      else  
        "/napi/browse/movies_at_home"
      end
    end

    def parse_result(result)
      document = JSON.parse(result)

      movies = document.dig('grid', 'list')

      # Collect all movie URLs
      movie_urls = movies.map { |movie| movie.fetch('mediaUrl') }
    end

    def check_next_page(result)
      document = JSON.parse(result)

      [document.dig('pageInfo', 'endCursor'), document.dig('pageInfo', 'hasNextPage')]
    end
end
