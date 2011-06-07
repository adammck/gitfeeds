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
    repo = Repo.new :url=>"git://github.com/adammck/gitfeed.git"
    assert repo.valid?
  end

  test "should not allow duplicate urls" do
    assert Repo.create(:url=>example_repo_url).valid?
    assert Repo.create(:url=>example_repo_url).invalid?
  end

  test "should raise Repo::NotCloned if the repo is queried before cloning" do
    assert_raises Repo::NotCloned do
      Repo.new(:url=>example_repo_url).commits
    end
  end

  test "should return a reverse-chronological list of all commits" do
    repo = Repo.create! :url=>example_repo_url
    ca = repo.commits(false)

    assert_equal "remove one and two.", ca.first.message # newest
    assert_equal "add one.", ca.last.message # oldest
    assert_equal 5, ca.length
  end

  test "should limit the number of commits returned" do
    repo = Repo.create! :url=>example_repo_url
    Rails.configuration.recent_commits = 2

    assert_equal 2, repo.commits.length    # app config
    assert_equal 1, repo.commits(1).length # explicit
  end
end
