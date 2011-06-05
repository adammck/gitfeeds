#!/usr/bin/env ruby
# vim: et ts=2 sw=2

class Repo < ActiveRecord::Base
  validates :url, :presence=>true, :is_git_url=>true

  after_create :clone_local
  after_destroy :delete_local

  # raised when calling methods which require a local clone before it exists.
  class NotCloned < RuntimeError; end


  def commits
    grit.commits
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
    Rails.root.join "tmp", "repos", id.to_s + ".git"
  end

  def grit
    raise NotCloned unless path.exist?
    Grit::Repo.new(path)
  end
end
