#!/usr/bin/env ruby
# vim: et ts=2 sw=2

GitFeeds::Application.routes.draw do

  # home page
  get "/"  => "repos#new",    :as=>:new_repo
  post "/" => "repos#create", :as=>:repos

  # repo show and feeds
  # i can't use resources here, because of the globs. (i think.)
  get "/*id/commits(.:format)" => "repos#commits", :as=>:commits_repo
  get "/*id/tags(.:format)"    => "repos#tags",    :as=>:tags_repo
  get "/*id/weekly(.:format)"  => "repos#weekly",  :as=>:weekly_repo
  get "/*id"                   => "repos#show",    :as=>:repo
end
