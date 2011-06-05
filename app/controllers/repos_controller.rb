#!/usr/bin/env ruby
# vim: et ts=2 sw=2

class ReposController < ApplicationController

  # GET /:id
  def show
    @repo = Repo.find(params[:id])
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
end
