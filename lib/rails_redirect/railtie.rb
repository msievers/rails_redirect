class RailsRedirect
  if defined?(Rails)
    class Railtie < Rails::Railtie
      initializer "rails_redirect.insert_middleware" do
        Rails.application.middleware.insert_before(0, "RailsRedirect") # push this at the very beginning
      end
    end
  end
end
