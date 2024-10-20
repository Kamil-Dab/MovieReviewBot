# frozen_string_literal: true

require "rails_helper"

RSpec.describe Website::Rottentomatoes::MovieCrawlerJob do
  describe "#perform" do
    let(:path) { "/m/the_wild_robot" } # Example path for the Rotten Tomatoes movie page

    before do
      # Set the queue adapter to test mode
      ActiveJob::Base.queue_adapter = :test
    end

    it "crawls movie data and enqueues reviews crawler job" do
      VCR.use_cassette(
        described_class.to_s.underscore,
        record: :none,
        match_requests_on: [:headers, :uri, :method, :body]
      ) do
        expect {
          described_class.perform_now(path)
        }.to change { Website::Rottentomatoes::ReviewsCrawlerJob.jobs.size }.by(1)
      end
    end
  end
end
