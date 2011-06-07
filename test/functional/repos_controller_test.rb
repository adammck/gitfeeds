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
      assert_redirected_to repo_path(assigns(:repo))
    end
  end

  test "should not create invalid repos" do
    post :create, :repo=>{ :url=>invalid_repo_url }
    assert_not_nil assigns(:repo)
    assert_template "repos/new"
    assert_select "ul.errors"
  end


  # repos/:id

  test "should show list of recent commits" do
    repo = Repo.create(:url=>example_repo_url)
    get :show, :id=>repo.to_param

    assert_not_nil assigns(:repo)
    assert_template "repos/show"

    assert_select "ul.commits" do
      assert_select "li", 5
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
