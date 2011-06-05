#!/usr/bin/env ruby
# vim: et ts=2 sw=2

class IsGitUrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :not_a_git_url)
  end
end
