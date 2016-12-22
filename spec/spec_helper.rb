$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

if !ENV["CI"]
  begin
    require "pry"
  rescue LoadError # rubocop:disable Lint/HandleExceptions
  end

  require "simplecov"
  SimpleCov.start
end

require "rails_redirect"

require "active_support"
require "active_support/core_ext/string" # strip_heredoc
