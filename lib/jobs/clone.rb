#!/usr/bin/env ruby
# vim: et ts=2 sw=2

class CloneJob
  include Resque::Plugins::UniqueJob
  @queue = :clones

  def self.perform(repo_id)
    Repo.find(repo_id).clone!
  end
end