#!/usr/bin/env ruby
# vim: et ts=2 sw=2

require "simplecov"
SimpleCov.start "rails"

ENV["RAILS_ENV"] = "test"

require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"

class ActiveSupport::TestCase
  fixtures :all

  # Return the local path to the example repo.
  def example_repo_url
    "file://" + Rails.root.join("test", "dot_git").to_s
  end

  # Return an arbitrary invalid repo url.
  def invalid_repo_url
    "invalid"
  end

  # Return a list of the weeks which commits were made to the example repo.
  def example_repo_weeks
    [
      DateTime.new(2011, 05, 30), # commits on: Sun Jun 5 04:33:25 2011 -0400
      DateTime.new(2011, 07, 10)  # commits on: Mon Jul 11 21:10:03 2011 -0400
    ]
  end
end
