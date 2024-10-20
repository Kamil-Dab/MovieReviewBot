# frozen_string_literal: true

module Website::Rottentomatoes::Crawler
  extend self

  BASE_URL = "https://www.rottentomatoes.com"

  def connect
    Faraday.new(
      url: BASE_URL,
      headers: headers()
    )
  end

  def headers
    { "Content-Type" => "application/json" }
  end
end
