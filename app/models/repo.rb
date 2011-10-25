#!/usr/bin/env ruby
# vim: et ts=2 sw=2

class Repo < ActiveRecord::Base
  validates :url, :presence=>true, :uniqueness=>true, :is_git_url=>true

  after_create :schedule_clone
  after_destroy :delete_local

  # raised when calling methods which require a local clone before it exists.
  class NotCloned < RuntimeError; end


  def to_param
    url
  end

  # Clone the repo locally. This can be very slow, so should be called from a
  # background worker. See +CloneJob+ for that.
  def clone!
    git = Grit::Git.new("/tmp")
    git.native(:clone, { :bare=>true }, url, path.to_s)
  end

  # Block until the repo has been cloned, and is available for querying.
  def block_until_cloned!
    while not path.exist?
      sleep(0.5)
    end
  end


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

  # Return all commits made between +from+ and +to+.
  def commits_between(from, to)
    Grit::Commit.find_all(grit, "master", {
      :since=>from, :until=>to })
  end

  # Return all commits made during +week+.
  def commits_for_week(week)
    commits_between(
      week.beginning_of_week,
      week.end_of_week)
  end

  # Return the +max_count+ most recent weeks containing commits, or all weeks if
  # +max_count+ is false.
  def commits_by_week(max_count=nil)
    max_count = Rails.configuration.recent_weeks if max_count.nil?
    week = DateTime.now.beginning_of_week
    weeks = []

    # keep collecting weeks until we have enough.
    while weeks.length < max_count && week > DateTime.new(2011)
      commits = commits_for_week(week)
      if commits.any?
        weeks << Week.new(week, commits)
      end
      week -= 1.week
    end

    weeks
  end


  private

  # If background jobs are enabled, queue a +CloneJob+ to clone this repo at
  # some undefined point in the future. If disabled, clone the repo immediately.
  def schedule_clone
    if Rails.configuration.background_jobs
      Resque.enqueue(CloneJob, id)

    else
      clone!
    end
  end

  def delete_local
    path.rmtree if path.exist?
  end

  def path
    Rails.root.join "tmp", "repos", Rails.env, id.to_s + ".git"
  end

  def grit
    raise NotCloned unless path.exist?
    Grit::Repo.new(path)
  end
end
