#!/usr/bin/env ruby
# vim: et ts=2 sw=2

require File.expand_path("../boot", __FILE__)
require "rails/all"

Bundler.require(:default, Rails.env)\
  if defined?(Bundler)

module GitFeeds
  class Application < Rails::Application

    # rails config
    config.filter_parameters += [:password]
    config.assets.enabled = true

    # gitfeeds config
    config.background_jobs = true
    config.recent_commits = 20
    config.recent_tags = 20
    config.recent_weeks = 8
  end
end
