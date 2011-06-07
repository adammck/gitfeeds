#!/usr/bin/env ruby
# vim: et ts=2 sw=2

module ApplicationHelper
  def commit_message(commit)
    commit.message.sub(/^#{commit.short_message}/, "").strip
  end
end
