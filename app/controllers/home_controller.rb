#!/usr/bin/env ruby
# vim: et ts=2 sw=2

class HomeController < ApplicationController
  def index
    @repo = Repo.new
  end
end
