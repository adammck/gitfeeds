#!/usr/bin/env ruby
# vim: et ts=2 sw=2

class IsGitUrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.blank?
      unless is_git_url?(value)
        record.errors.add(attribute, :not_a_git_url)
      end
    end
  end

  private

  # Return true if +url+ appears to be a valid Git URL.
  def is_git_url?(url, ref="HEAD")
    out = git.native(:ls_remote, { }, url, ref)
    out.strip.match /^[0-9a-z]{40}\t#{ref}$/
  end

  def git
    Grit::Git.new("/tmp")
  end
end
