#!/usr/bin/env ruby
# vim: et ts=2 sw=2

class Repo < ActiveRecord::Base
  validates :url, :presence=>true, :is_git_url=>true
end
