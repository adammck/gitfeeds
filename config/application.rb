#!/usr/bin/env ruby
# vim: et ts=2 sw=2

require File.expand_path("../boot", __FILE__)
require "rails/all"

Bundler.require(:default, Rails.env)\
  if defined?(Bundler)

module GitFeed
  class Application < Rails::Application
    config.filter_parameters += [:password]
  end
end
