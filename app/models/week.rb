#!/usr/bin/env ruby
# vim: et ts=2 sw=2

class Week
  attr_reader :datetime, :commits

  def initialize(datetime, commits)
    @datetime = datetime
    @commits = commits
  end
end
