# Use the official Ruby image as the base
FROM ruby:3.2.3-slim

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    yarn

# Set the working directory inside the container
WORKDIR /app

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock ./

# Install Ruby gems
RUN bundle install

# Copy the rest of the application code
COPY . ./

# Precompile assets (optional, if you have assets to compile)
# RUN bundle exec rake assets:precompile

# Expose port 3000 to the host machine
EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
