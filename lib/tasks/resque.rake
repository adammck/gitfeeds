#!/usr/bin/env ruby
# vim: et ts=2 sw=2

require "resque/tasks"

task "resque:setup"=>:environment do
  Grit::Git.git_timeout = 10.minutes
end