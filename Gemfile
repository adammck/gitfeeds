#!/usr/bin/env ruby
# vim: et ts=2 sw=2

source "http://rubygems.org"

gem "rails", "3.1.0"
gem "coffee-rails"
gem "sass-rails"
gem "uglifier"

gem "sqlite3"
gem "grit", :git=>"git://github.com/adammck/grit.git"

gem "resque"
gem "resque-loner"

# use require_all for loading jobs.
gem "require_all"

# use simplecov for test coverage reports.
# use turn for better test output (until rails 3.1).
# use resque_unit to test background jobs.
group :test do
  gem "simplecov"
  gem "minitest"
  gem "turn"
  gem "resque_unit"
end

# use thin, since webrick crashes when crunching large repos.
# start the development server with: rails server thin
group :development do
  gem "thin"
end