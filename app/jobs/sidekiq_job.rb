# frozen_string_literal: true

class SidekiqJob
  include Sidekiq::Job

  # Perform the job synchronously
  def self.perform_now(*args)
    perform_inline(*args)
  end

  # Perform the job asynchronously (default Sidekiq behavior)
  def self.perform_later(*args)
    perform_async(*args)
  end
end
