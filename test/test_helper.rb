#!/usr/bin/env ruby
# vim: et ts=2 sw=2

require "simplecov"
SimpleCov.start "rails"

ENV["RAILS_ENV"] = "test"

require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"

class ActiveSupport::TestCase
  fixtures :all

  def example_repo_url
    "file://" + Rails.root.join("test", "dot_git").to_s
  end

  def invalid_repo_url
    "invalid"
  end
end
