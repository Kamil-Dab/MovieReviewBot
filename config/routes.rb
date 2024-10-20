require "sidekiq/web"

Rails.application.routes.draw do
  if Rails.env.production?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      # TBD Replace by authentication logic
      username == ENV['SIDEKIQ_USERNAME'] && password == ENV['SIDEKIQ_PASSWORD']
    end
  end

  # Mount the Sidekiq web interface at "/sidekiq"
  mount Sidekiq::Web => '/sidekiq'
end