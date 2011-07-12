#!/usr/bin/env ruby
# vim: et ts=2 sw=2

require "test_helper"

class ReposControllerTest < ActionController::TestCase
  def teardown
    Repo.destroy_all
  end


  # repos#new (home page)

  test "should get new repo form" do
    get :new

    assert_response :success
    assert_not_nil assigns(:repo)
    assert_template "repos/new"
  end

  test "should create repo" do
    assert_difference("Repo.count", 1) do
      post :create, :repo=>{ :url=>example_repo_url }

      assert_response :redirect
      assert_not_nil assigns(:repo)
      assert_redirected_to repo_path(assigns(:repo))
    end
  end

  test "should not create invalid repos" do
    assert_no_difference("Repo.count") do
      post :create, :repo=>{ :url=>invalid_repo_url }

      assert_response :success
      assert_not_nil assigns(:repo)
      assert_template "repos/new"
      assert_select "ul.errors"
    end
  end


  # repos/:id

  test "should show list of recent commits and tags" do
    repo = Repo.create(:url=>example_repo_url)
    get :show, :id=>repo.to_param

    assert_response :success
    assert_not_nil assigns(:repo)
    assert_template "repos/show"

    # test/dot_git repo has five commits.
    assert_select ".commits ul" do
      assert_select "li", 5
    end

    # test/dot_git repo has three tags.
    assert_select ".tags ul" do
      assert_select "li", 3
    end
  end

  test "should create valid but new repos on-demand" do
    assert_difference("Repo.count", 1) do
      get :show, :id=>example_repo_url

      assert_response :success
      assert_not_nil assigns(:repo)
      assert_template "repos/show"
    end
  end

  test "should not create invalid repos on-demand" do
    assert_no_difference("Repo.count") do
      get :show, :id=>invalid_repo_url

      assert_response :missing
      assert_not_nil assigns(:repo)
      assert_template "repos/new"
    end
  end


  # repos/:id/commits.rss

  test "should get a reverse-chronological feed of recent commits" do
    repo = Repo.create(:url=>example_repo_url)
    get :commits, :id=>repo.to_param, :format=>"rss"

    assert_response :success
    assert_not_nil assigns(:repo)
    assert_not_nil assigns(:commits)

    assert_select "channel" do
      assert_select "item:first-of-type > title", "remove one and two."
      assert_select "item:last-of-type > title", "add one."
      assert_select "item", :count=>5
    end
  end


  # repos/:id/tags.rss

  test "should get a reverse-chronological feed of recent tags" do
    repo = Repo.create(:url=>example_repo_url)
    get :tags, :id=>repo.to_param, :format=>"rss"

    assert_response :success
    assert_not_nil assigns(:repo)
    assert_not_nil assigns(:tags)

    assert_select "channel" do
      assert_select "item:first-of-type > title", "three_four"
      assert_select "item:last-of-type > title", "one_two"
      assert_select "item", :count=>3
    end
  end


  # unimplemented resourceful actions

  test "should not get index" do
    assert_no_route do
      get :index
    end
  end

  test "should not get edit repo form" do
    assert_no_route do
      get :edit, :id=>1
    end
  end

  test "should not put repo" do
    assert_no_route do
      put :update, :id=>1
    end
  end

  test "should not delete repo" do
    assert_no_route do
      delete :update, :id=>1
    end
  end


  private

  def assert_no_route
    assert_raises ActionController::RoutingError do
      yield
    end
  end
end
