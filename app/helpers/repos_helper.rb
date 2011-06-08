#!/usr/bin/env ruby
# vim: et ts=2 sw=2

module ReposHelper
  def example_repos
    Repo.last(4).reverse
  end
end
