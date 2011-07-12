#!/usr/bin/env ruby
# vim: et ts=2 sw=2

class ReposController < ApplicationController
  before_filter :load_repo, :except=>[:new, :create]


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


  # GET /:id
  def show
  end

  # GET /:id/commits.rss
  def commits
    @commits = @repo.commits(20)

    respond_to do |fmt|
      fmt.rss
    end
  end

  # GET /:id/tags.rss
  def tags
    @tags = @repo.tags(20)

    respond_to do |fmt|
      fmt.rss
    end
  end


  private

  # if a previously-unknown repo url is requested, try to create it on-demand.
  # this allows people to link to repos on gitfeeds.com without having to create
  # them in advance. if the id (clone url) is invalid, abort by rendering the
  # create form with errors.
  def load_repo
    @repo = Repo.find_or_create_by_url(fixed_id)
    render :new, :status=>404 unless @repo.persisted?
  end

  # the cgi spec dictates that adjacent slashes are collapsed in PATH_INFO, so
  # although +http://hosta/git://hostb/path.git+ is matched correctly by rails
  # (via the +/*id+ route),  params[:id] is set to +git:/hostb/path.git+. this
  #  method is a kludgy fix, so all repos can store their real url.
  def fixed_id

    # replace scheme:/X with scheme://X
    # from rfc3986 section 3.1 (page 16):
    #   scheme = ALPHA *( ALPHA / DIGIT / "+" / "-" / "." )
    params[:id].sub %r{^([a-z][a-z0-9\+\-\.]*):/([^/]+)}i, '\1://\2'
  end
end
