#!/usr/bin/env ruby
# vim: et ts=2 sw=2

module ApplicationHelper
  def commit_message(commit)
    sm = Regexp.escape(commit.short_message)
    commit.message.sub(/^#{sm}\n*/, "").strip
  end
end
