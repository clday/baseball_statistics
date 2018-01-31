# Baseball Batting Stat Tracker

This app provides an easy to use interface for looking at baseball players, their associated statistics and viewing statistical leaders for batting average and slugging percentage across several different criteria.

## Setup the application
This assumes that you already have postgres, ruby 2.5.0 (using RVM) and bundler installed.

Install all the gems
```bash
bundle install
```

Setup the DB
```bash
bundle exec rake db:create db:migrate
```

Run the server
```bash
bundle exec rails s
```
## Running tests
Tests are written with RSpec and Capybara, so running them is very simple:
```bash
bundle exec rspec
```

## Seeding the database
Two CSVs are provided in the repo for seeding the database with thousands of players and seasons of batting statistics
A handy rake task is provided
Upload the provided player data
```bash
bundle exec rake import_csv['player','db/data/players.csv']
```
*Note* Players are identified by their `player_id`, so batting statistics must be linked to them through this id

Upload the provided batting statistics
```bash
bundle exec rake import_csv['batting','db/data/batting.csv']
```
*Note* Batting statistics will not be uploaded if there is no associated player in the database

## Future Ideas and Todos
- Upload players and statistics via the web interface
- Regular scraping of baseball-reference.com for new statistics and players
- More player details (height, weight, birth date)
- Data visualization
