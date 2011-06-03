#!/usr/bin/env ruby
# vim: et ts=2 sw=2

ENV["RAILS_ENV"] = "test"

require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"

class ActiveSupport::TestCase
  fixtures :all
end
