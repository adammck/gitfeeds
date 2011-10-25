#!/usr/bin/env ruby
# vim: et ts=2 sw=2

require "test_helper"

class RepoTest < ActiveSupport::TestCase
  def teardown
    Repo.destroy_all
  end

  test "should not validate without an url" do
    assert Repo.new.invalid?
  end

  test "should not validate with an invalid (non-rfc3986) url" do
    invalid_urls = [
      "example.com",  # missing scheme
      "http://bang!", # invalid ascii
      "git://\u2713"  # unicode
    ]

    invalid_urls.each do |url|
      repo = Repo.new :url=>url
      assert repo.invalid?
    end
  end

  test "should not validate with a valid url which is not a git repo" do
    repo = Repo.new :url=>"http://example.com"
    assert repo.invalid?
  end

  test "should validate with a valid git repo url" do
    repo = Repo.new :url=>"git://github.com/adammck/gitfeeds.git"
    assert repo.valid?
  end

  test "should not allow duplicate urls" do
    assert Repo.create(:url=>EXAMPLE_REPO_URL).valid?
    assert Repo.create(:url=>EXAMPLE_REPO_URL).invalid?
  end

  test "should raise Repo::NotCloned if the repo is queried before cloning" do
    assert_raises Repo::NotCloned do
      Repo.new(:url=>EXAMPLE_REPO_URL).commits
    end
  end

  test "should create a resque job to clone asynchronously" do
    with_config :background_jobs=>true do
      repo = Repo.create! :url=>EXAMPLE_REPO_URL
      assert_queued(CloneJob, [repo.id])

      # TODO: extract this into a separate CloneJobTest.
      Resque.run!
      assert repo.ready?
    end
  end


  # commits

  test "should return a reverse-chronological list of all commits" do
    repo = Repo.create! :url=>EXAMPLE_REPO_URL
    ca = repo.commits(false)

    assert_equal TOTAL_COMMITS, ca.length
    assert_equal NEWEST_COMMIT_MSG, ca.first.message
    assert_equal OLDEST_COMMIT_MSG, ca.last.message
  end

  test "should limit the number of commits returned" do
    with_config :recent_commits=>2 do
      repo = Repo.create! :url=>EXAMPLE_REPO_URL

      assert_equal 2, repo.commits.length    # app config
      assert_equal 1, repo.commits(1).length # explicit
    end
  end


  # commits by date

  test "should return commits between two dates" do
    repo = Repo.create! :url=>EXAMPLE_REPO_URL

    commits = repo.commits_between(
      EXAMPLE_REPO_WEEKS.first.beginning_of_week,
      EXAMPLE_REPO_WEEKS.first.end_of_week)

    assert_equal FIRST_WEEK_COMMITS, commits.length
    assert_equal "remove one and two.", commits.first.message # newest
    assert_equal "add one.", commits.last.message             # oldest
  end

  test "should return commits for a week" do
    repo = Repo.create! :url=>EXAMPLE_REPO_URL
    commits = repo.commits_for_week(EXAMPLE_REPO_WEEKS.first)

    assert_equal FIRST_WEEK_COMMITS, commits.length
    assert_equal "remove one and two.", commits.first.message # newest
    assert_equal "add one.", commits.last.message             # oldest
  end

  test "should return empty array for empty weeks" do
    repo = Repo.create! :url=>EXAMPLE_REPO_URL
    week = EXAMPLE_REPO_WEEKS.first - 1.month
    assert_equal [], repo.commits_for_week(week)
  end


  # commits by week

  test "should return weeks containing commits" do
    repo = Repo.create! :url=>EXAMPLE_REPO_URL
    weeks = repo.commits_by_week

    assert_equal EXAMPLE_REPO_WEEKS.length, weeks.length
    assert_equal EXAMPLE_REPO_WEEKS.last, weeks.first.datetime # newest
    assert_equal EXAMPLE_REPO_WEEKS.first, weeks.last.datetime # oldest
  end


  # tags

  test "should return a reverse-chronological list of all tags" do
    repo = Repo.create! :url=>EXAMPLE_REPO_URL
    ta = repo.tags(false)

    assert_equal TOTAL_TAGS, ta.length
    assert_equal "three_four", ta.first.name # newest
    assert_equal "one_two", ta.last.name     # oldest
  end

  test "should limit the number of tags returned" do
    with_config :recent_tags=>2 do
      repo = Repo.create! :url=>EXAMPLE_REPO_URL

      assert_equal 2, repo.tags.length    # app config
      assert_equal 1, repo.tags(1).length # explicit
    end
  end
end
