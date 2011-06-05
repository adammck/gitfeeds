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

  test "should raise Repo::NotCloned if the repo is queried before cloning" do
    assert_raises Repo::NotCloned do
      Repo.new(:url=>example_repo_url).commits
    end
  end

  test "should fetch a list of all commits" do
    repo = Repo.create! :url=>example_repo_url
    assert repo.commits.length == 5
  end
end