class RailsRedirect
  class Config
    attr_accessor :rules

    def initialize(config = nil)
      if config.nil? && defined?(Rails)
        rails_config_basename = "rails_redirect"

        if File.exist?(Rails.root.join("config", "#{rails_config_basename}.yml"))
          config = Rails.application.config_for(rails_config_basename)
        end
      end

      @rules = config["rules"].map { |rule_definition| Rule.new(rule_definition) }
    end
  end
end
