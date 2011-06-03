#!/usr/bin/env ruby
# vim: et ts=2 sw=2

GitFeed::Application.configure do
  config.cache_classes                     = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.action_dispatch.x_sendfile_header = "X-Accel-Redirect"
  config.serve_static_assets               = false
  config.i18n.fallbacks                    = true
  config.active_support.deprecation        = :notify
end
