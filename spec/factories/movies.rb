FactoryBot.define do
  factory :movie do
    sequence(:movie_id) { |n| "movie_id_#{n}" }
    title { "Sample Movie Title" }
  end
end