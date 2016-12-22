require_relative "./rails_redirect/config"
require_relative "./rails_redirect/railtie"
require_relative "./rails_redirect/rule"
require_relative "./rails_redirect/version"

class RailsRedirect
  def initialize(app)
    @app = app
    @config = RailsRedirect::Config.new
  end

  def call(env)
    body = status = nil
    original_url = url = [env["rack.url_scheme"], "://", env["HTTP_HOST"], env["SCRIPT_NAME"], env["PATH_INFO"]].join

    while matched_rule = @config.rules.find { |rule| rule.match?(url) }
      status, url, body = matched_rule.apply(url)
    end

    if url != original_url
      [
        status, {
          "Content-Type" => "text/html; charset=utf-8",
          "Location" => url
        },
        [body] # rack assumes this to respond to each
      ]
    else
      @app.call(env)
    end
  end
end
