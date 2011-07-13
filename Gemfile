#!/usr/bin/env ruby
# vim: et ts=2 sw=2

source "http://rubygems.org"

gem "rails", "3.0.7"
gem "sqlite3"
gem "grit", :git=>"git://github.com/adammck/grit.git"

# avoid rake 0.9 deprecation warnings.
# (remove when upgrading to rails 3.1.)
gem "rake", "0.8.7"

# use simplecov for test coverage reports.
# use turn for better test output (until rails 3.1).
group :test do
  gem "simplecov"
  gem "turn"
end

# use thin, since webrick crashes when crunching large repos.
# start the development server with: rails server thin
group :development do
  gem "thin"
end