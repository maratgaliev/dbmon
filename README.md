
# DBMON

## Why?

Simple UI dashboard for your Rails apps, shows DB usage statistics.

Adapters supported:

- PostgreSQL [via `ruby-pg-extras` gem]

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dbmon'
```

And then execute:

```ruby
$ bundle
```

Or install it yourself as:

```ruby
$ gem install dbmon
```

## Usage

Set your ENV variable:

```bash
export MON_DATABASE_URL="postgresql://postgres:postgres@HOST:PORT/DBNAME"
```

Add to your routes.rb:

```ruby
require 'dbmon/web'
mount Dbmon::Web => '/dbmon'
```

Navigate to:

```ruby
http://HOST:PORT/dbmon
```

## Screenshots

![dbmon](https://api.monosnap.com/file/download?id=3wXxAqPqUxEzlMnCja9S8Fyb1YKJJZ)


![dbmon2](https://api.monosnap.com/file/download?id=b0t4l7XAF0PXUhJAsiCIoljZple2U8)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/maratgaliev/dbmon. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DBMON project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/maratgaliev/dbmon/blob/master/CODE_OF_CONDUCT.md).
