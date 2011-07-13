#!/usr/bin/env ruby
# vim: et ts=2 sw=2

require "simplecov"
SimpleCov.start "rails"

ENV["RAILS_ENV"] = "test"

require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"

class ActiveSupport::TestCase
  fixtures :all

  # The total number of commits made to the example repo.
  TOTAL_COMMITS = 7

  # The number of commits made to the example repo in the first week.
  FIRST_WEEK_COMMITS = 5

  # The total number of tags in the example repo.
  TOTAL_TAGS = 3

  # The commit message of the oldest commit made to the example repo.
  OLDEST_COMMIT_MSG = "add one."

  # The commit message of the most recent commit made to the example repo.
  NEWEST_COMMIT_MSG = "remove four and add six."

  # The git URL of the example repo.
  EXAMPLE_REPO_URL = "file://" + Rails.root.join("test", "dot_git").to_s

  # An invalid repo URL.
  INVALID_REPO_URL = "invalid"

  # The weeks which commits were made to the example repo.
  EXAMPLE_REPO_WEEKS = [
    DateTime.parse("Mon, 30 May 2011 00:00:00 -0400"),
    DateTime.parse("Mon, 11 Jul 2011 00:00:00 -0400")]
  end
end
