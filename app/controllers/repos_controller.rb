#!/usr/bin/env ruby
# vim: et ts=2 sw=2

class ReposController < ApplicationController
  before_filter :load_repo, :except => [:new, :create]

  # GET /:id
  def show
  end

  # GET /
  def new
    @repo = Repo.new
  end

  # POST /
  def create
    @repo = Repo.find_or_initialize_by_url(params[:repo])
    if @repo.persisted? or @repo.save
      redirect_to(repo_path(@repo))
    else
      render :new
    end
  end

  # GET /:id/commits.rss
  def commits
    @commits = @repo.commits(20)

    respond_to do |fmt|
      fmt.rss
    end
  end

  def load_repo
    @repo = Repo.find(params[:id])
  end
end
