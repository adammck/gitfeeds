#!/usr/bin/env ruby
# vim: et ts=2 sw=2

module ApplicationHelper
  def commit_message(commit)
    sm = Regexp.escape(commit.short_message)
    commit.message.sub(/^#{sm}\n*/, "").strip
  end

  def format_week(week)
    week.datetime.strftime("%m/%d/%y")
  end
end
