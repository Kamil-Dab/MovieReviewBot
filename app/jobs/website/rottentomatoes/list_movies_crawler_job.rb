# frozen_string_literal: true

class Website::Rottentomatoes::ListMoviesCrawlerJob < SidekiqJob
  queue_as :default

  def perform
    connect = Website::Rottentomatoes::Crawler.connect()
    crawled_data = Website::CreateCrawledData.call(
      path, connect, "get"
    )

    parse_result(crawled_data.result).each do |movie_url|
      Website::Rottentomatoes::MovieCrawlerJob.perform_now(movie_url)
    end
  end

  private
    def path
      "/browse/movies_at_home"
    end

    def parse_result(result)
      document = Nokogiri::HTML(result)
      puts document

      json_ld_script = document.at('script[type="application/ld+json"]')
      puts "Dupa"
      puts json_ld_script
      json_ld_data = JSON.parse(json_ld_script.content)
      puts "Dupa2"
      puts json_ld_data
      movies = json_ld_data.dig('itemListElement')
      puts "Dupa3"
      movies= movies.dig('itemListElement')
      puts movies

      # Collect all movie URLs
      movie_urls = movies.map { |movie| movie.dig('url').sub('https://www.rottentomatoes.com', '') }
    end
end
