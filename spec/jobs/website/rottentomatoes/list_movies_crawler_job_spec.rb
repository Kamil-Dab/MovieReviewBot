# frozen_string_literal: true

require "rails_helper"

RSpec.describe Website::Rottentomatoes::ListMoviesCrawlerJob do
  describe "#perform" do
    let(:end_cursor) { "Nw=" } # Example end cursor for pagination

    before do
      # Set the queue adapter to test mode
      ActiveJob::Base.queue_adapter = :test
    end

    it "crawls the list of movies and enqueues MovieCrawlerJob for each movie" do
      VCR.use_cassette(
        described_class.to_s.underscore,
        record: :none,
        match_requests_on: [:headers, :uri, :method, :body]
      ) do
        expect {
          described_class.perform_now(end_cursor)
        }.to change { Website::Rottentomatoes::MovieCrawlerJob.jobs.size }.by_at_least(1)
      end
    end

    it "enqueues the next ListMoviesCrawlerJob if there is a next page" do
      VCR.use_cassette(
        "#{described_class.to_s.underscore}_next_page",
        record: :none,
        match_requests_on: [:headers, :uri, :method, :body]
      ) do
        expect {
          described_class.perform_now(end_cursor)
        }.to change { Website::Rottentomatoes::ListMoviesCrawlerJob.jobs.size }.by(1)
      end
    end

    it "does not enqueue another ListMoviesCrawlerJob if there is no next page" do
      VCR.use_cassette(
        "#{described_class.to_s.underscore}_no_next_page",
        record: :none,
        match_requests_on: [:headers, :uri, :method, :body]
      ) do
        expect {
          described_class.perform_now(end_cursor)
        }.not_to change { Website::Rottentomatoes::ListMoviesCrawlerJob.jobs.size }
      end
    end
  end
end
