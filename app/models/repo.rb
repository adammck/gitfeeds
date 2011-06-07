#!/usr/bin/env ruby
# vim: et ts=2 sw=2

class Repo < ActiveRecord::Base
  validates :url, :presence=>true, :uniqueness=>true, :is_git_url=>true

  after_create :clone_local
  after_destroy :delete_local

  # raised when calling methods which require a local clone before it exists.
  class NotCloned < RuntimeError; end


  # Return the +max_count+ most recent commits, or all commits if +max_count+ is
  # false. (Warning: Trying to fetch all commits crashes WEBrick, and is dumb.)
  def commits(max_count=nil)
    max_count = Rails.configuration.recent_commits if max_count.nil?
    grit.commits("master", max_count)
  end

  # Return +max_count+ most recent tags, or all tags if +max_count+ is false.
  def tags(max_count=nil)
    max_count = Rails.configuration.recent_tags if max_count.nil?
    (max_count == false) ? grit.tags : grit.tags[0, max_count]
  end


  private

  def clone_local
    git = Grit::Git.new("/tmp")
    git.native(:clone, { :bare=>true }, url, path.to_s)
  end

  def delete_local
    path.rmtree
  end

  def path
    Rails.root.join "tmp", "repos", Rails.env, id.to_s + ".git"
  end

  def grit
    raise NotCloned unless path.exist?
    Grit::Repo.new(path)
  end
end
