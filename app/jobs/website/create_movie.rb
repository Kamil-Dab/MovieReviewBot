require "nokogiri"

class Website::CreateMovie
  def self.call(result)
    new(result).upsert_movie()
  end

  def initialize(result)
    @result = result
  end

  attr_reader :result


  def upsert_movie
    Movie.upsert(
      format_crawled_data().merge(created_at: Time.current, updated_at: Time.current),
      unique_by: :movie_id,
      returning: %w[movie_id]
    )
  end

  def format_crawled_data
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
