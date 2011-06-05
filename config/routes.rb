#!/usr/bin/env ruby
# vim: et ts=2 sw=2

GitFeed::Application.routes.draw do
  root :to=>"home#index"
end
