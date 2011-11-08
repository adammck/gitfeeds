#!/usr/bin/env ruby
# vim: et ts=2 sw=2

class PullJob
  include Resque::Plugins::UniqueJob
  @queue = :pulls

  def self.perform(repo_id)
    Repo.find(repo_id).pull!
  end
end