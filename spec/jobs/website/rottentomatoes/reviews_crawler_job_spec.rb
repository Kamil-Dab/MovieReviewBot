# frozen_string_literal: true

require "rails_helper"

RSpec.describe Website::Rottentomatoes::ReviewsCrawlerJob do
  describe "#perform" do
    let(:movie_id) { "dd36be73-6c5e-3b4b-94e2-4b62260e2808" }

    before do
      # Set the queue adapter to test mode
      ActiveJob::Base.queue_adapter = :test
      create(:movie, movie_id: movie_id)
    end

    context "when there is a next page" do
      let(:end_cursor) { "Ng==" }

      it "crawls reviews data and enqueues another ReviewsCrawlerJob" do
        VCR.use_cassette(
          described_class.to_s.underscore,
          record: :none,
          match_requests_on: [:headers, :uri, :method, :body]
        ) do

          expect {
            described_class.perform_now(movie_id, end_cursor)
          }.to change { Website::Rottentomatoes::ReviewsCrawlerJob.jobs.size }.by(1)
        end
      end
    end

    context "when there is no next page" do
      let(:end_cursor) { "OQ==" }

      it "does not enqueue another ReviewsCrawlerJob" do
        VCR.use_cassette(
          "#{described_class.to_s.underscore}_no_next_page",
          record: :none,
          match_requests_on: [:headers, :uri, :method, :body]
        ) do

          expect {
            described_class.perform_now(movie_id, end_cursor)
          }.not_to change { Website::Rottentomatoes::ReviewsCrawlerJob.jobs.size }
        end
      end
    end
  end
end
