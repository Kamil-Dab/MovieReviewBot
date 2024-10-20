# frozen_string_literal: true

require "nokogiri"

class Website::Rottentomatoes::MovieCrawlerJob < SidekiqJob
  queue_as :defaul

  def perform
    connect = Website::Rottentomatoes::Crawler.connect()
    crawled_data = Website::CreateCrawledData.call(
      path, connect, "get"
    )
    puts format_crawled_data(crawled_data.result)
    Movie.upsert(
      format_crawled_data(crawled_data.result).merge(created_at: Time.current, updated_at: Time.current),
      unique_by: :movie_id
    )
  end

  private
    def path
      "/m/the_wild_robot"
    end

    def format_crawled_data(result)
      document = Nokogiri::HTML(result)

      title = document.xpath("//title").text.strip

      script_content = document.xpath("//script[contains(text(), 'RottenTomatoes.dtmData')]/text()").to_s
      match_data = script_content.match(/RottenTomatoes\.dtmData\s*=\s*(\{.*?\});/m)

      unless match_data
        raise "No data found for movie: #{title}"
      end

      json_data = JSON.parse(match_data[1])

      {
        title: title,
        genre: json_data["titleGenre"],
        movie_id: json_data["emsID"]
      }
    end
end
