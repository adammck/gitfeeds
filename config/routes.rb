#!/usr/bin/env ruby
# vim: et ts=2 sw=2

GitFeed::Application.routes.draw do
  resources :repos, :only=>[:new, :create, :show], :path=>"/", :path_names=>{ :new=>"" }
end
