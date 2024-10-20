# README
# MovieReviewBot

MovieReviewBot is a Ruby on Rails application that crawls and aggregates movie reviews from Rotten Tomatoes. It utilizes Sidekiq for background job processing, enabling efficient handling of various crawling tasks. The app supports fetching movie lists, individual movie details, and reviews.


## Features
- **Modular Crawlers**:
  - `MovieCrawlerJob`: Crawls individual movie details.
  - `ListMoviesCrawlerJob`: Fetches a list of movies for processing.
  - `ReviewsCrawlerJob`: Crawls movie reviews and handles pagination.


## Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/Kamil-Dab/MovieReviewBot.git
   cd MovieReviewBot
   ```
2. **Build and run app**
```
   docker compose build
   docker compose up 
```
## Usage
Start Crawling:

* You can manually enqueue crawling jobs via the Rails console:
```
docker comopose run app Website::Rottentomatoes::ListMoviesCrawlerJob.perform_later
```

## License
This project is licensed under the MIT License.

## Contact

If you have any questions or need further assistance, feel free to contact the project maintainers.

