#!/usr/bin/env ruby
# vim: et ts=2 sw=2

require "test_helper"

class HomeControllerTest < ActionController::TestCase
  test "should get index with url form" do
    get :index
    assert_response :success
    assert_select "input#url"
  end
end
