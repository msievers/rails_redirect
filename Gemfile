source "https://rubygems.org"

# Specify your gem's dependencies in zstandard.gemspec
gemspec

group :development do
  gem "activesupport"
  gem "benchmark-ips"
  gem "bundler"
  gem "rake"
  gem "rspec", "~> 3.0"
  gem "simplecov"
  
  # yard and friends 
  gem "redcarpet"
  gem "github-markup"
  gem "yard"

  if !ENV["CI"] && RUBY_ENGINE == "ruby"
    gem "pry"

    if RUBY_VERSION < "2.0.0"
      gem "pry-nav"
    else
      gem "pry-byebug"
    end
  end
end
