#!/usr/bin/env ruby
# vim: et ts=2 sw=2

namespace :gitfeeds do

  desc "Start a worker to keep local repos up to date"
  task :work=>:environment do
    loop do
      Repo.stale.each do |repo|
        puts "Scheduled PullJob for: #{repo}"
        repo.schedule_pull
      end

      sleep ENV['INTERVAL'] || 5
    end
  end
end