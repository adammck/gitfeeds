#!/usr/bin/env ruby
# vim: et ts=2 sw=2

require File.expand_path("../boot", __FILE__)
require "rails/all"

Bundler.require(:default, Rails.env)\
  if defined?(Bundler)

module GitFeed
  class Application < Rails::Application

    # rails config
    config.filter_parameters += [:password]

    # gitfeed config
    config.recent_commits = 20
    config.recent_tags = 20
  end
end
