# rails_redirect

A rails centric rack middleware to handle redirections.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_redirect'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_redirect

## Features

### Build for Rails

Although this is a rack middleware, it's primary focus is Rails. This allows for a tight integration and a superior *"works out-of-the-box"* feeling. Just add it to your `Gemfile`, create the config and things start rolling. The middleware is automatically injected into your stack. The config allows for multiple environments, just like `database.yml`.

### Resolves transitive redirections

In grown applications it's not uncommon, that you start with a collection `/foos`, which's url was renamed to `/bars` (probably for better SEO), just to be eventually being renamed to `/muffs` (for even better SEO). Legacy urls should be reachable even with your newest release, to not break peoples bookmarks.

To ease the pain of supporting multiple levels of redirection and in order to improve performance by avoiding multiple redirects, `rails_redirect` resolves transitive redirects and answers just with the final target. Having a config like this, a request to `/foos` will be directly answerd with a redirct to `/muffs` (no `/bars` involved).

```yaml
rules:
- /\/foos\/?\Z/: "/bars"
- /\/bars\/?\Z/: "/muffs"
```

### Regular expressions (with named captures)

*Selectors* can be written as regular expressions. Captures can be used within the *transformation* by using the well known `\1`, `\2`, `...` notation or by assigning meaningfully names. After all, it's just Ruby regular expressions.

```yaml
rules:
- /\/foos/(?<id>\d+)\Z/: "/muffs/\\k<id>" # redirects /foos/17 to /muffs/17
```

### Supports lambdas/procs

If regular expressions are not sufficient you can also use *lambdas/procs*.

```yaml
rules:
- /\/foos\/?\Z/: -> (url) { "/bars" }
- /\/bars\/?\Z/: |                    # multiple lines just work because of YAML
    -> (url) do
      "/muffs"
    end
```

## Usage

In your rails app, create `config/rails_redirect.yml` and set it up.

## Examples

```yaml
# config/rails_redirect.yml
default: &default
  rules:
  # redirect urls which end with "/de/collections" to "/de/sammlungen
  - /\/de\/collections\/?\Z/: "/de/sammlungen"
  
  # redirect urls like "/de/collections/foo" to "/de/sammlungen/foo
  - /\/de\/collections\/(?<id>[^\/]+)\Z/: "/de/sammlungen/\\k<id>"
  - /\/de\/sammlungen\/?\Z/: "/de/specials"
  - /\/de\/sammlungen\/(?<id>[^\/]+)\Z/: "/de/specials/\\k<id>"
  - /[^\/]+\/collections\Z/: |
      -> (url) do
        "/foo/bar"
      end

development:
  <<: *default

test:
  <<: *default

production:
  <<: *default
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/msievers/rails_redirect.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
