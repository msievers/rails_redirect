# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rails_redirect/version"

Gem::Specification.new do |spec|
  spec.name          = "rails_redirect"
  spec.version       = RailsRedirect::VERSION
  spec.authors       = ["Michael Sievers"]
  spec.summary       = %q{Rack middleware to ease redirections within rails.}
  spec.homepage      = "https://github.com/msievers/rails_redirect"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
