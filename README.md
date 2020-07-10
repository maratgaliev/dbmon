# DBMON

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

![dbmon](https://d3dehtdmp2rwcw.cloudfront.net/ms_87214/Re6MDlRemYWfHwPSVPczFkLafIAVcl/DBMON%2B%255BDEVELOPMENT%255D%2B-%2Bdatabase%2Busage%2B2020-07-10%2B01-39-49.png?Expires=1594360800&Signature=KPmXpeQdBdSlWnSWVAGggzNfo98Q8b9BMqTCOfscpfpVNi7882RE1O1FIg7WKnj~WnUBa5T3QXjS3~djjaJEDSD1QdBwtp1Ib7X3Y~8WMp2yPHsap-PoC06h5iPsLE~aR2BV33HtV23-uRkfTy1HoIohAUHP4plvL7hbhzCE1HUTrdISibhCZAkpWJCfflTLVVDbkRpDqtoLfZdifbxlw2~MuUNJS4PkbW3lYAOj~lKhVBqqe6rfYgflc0zxpCFY2sSeQkim4ShJyBJCFo4UONWyLM54rB6F51czTgRcYQl-LAWfzNx81L7FErWMdGkFvXsPNrVDsCJq-paWpJ4llg__&Key-Pair-Id=APKAJBCGYQYURKHBGCOA)


![dbmon2](https://d3dehtdmp2rwcw.cloudfront.net/ms_87214/mzD79sh0jztm6uHtC5ybE32PObipMq/DBMON%2B%255BDEVELOPMENT%255D%2B-%2Bdatabase%2Busage%2B2020-07-10%2B01-40-19.png?Expires=1594360800&Signature=wUy79uv92v4PFM2C1~cfQX6hO8JkhsH2yln1NOHV2AAgy9D82PvDASw1Cxy7MPEaFvnAGLv8FhPV020HwcYbmyQ7FKAOsNlX6C-PnlrcNWQyoJfESpYqLFN8T9S3g3zQcLBT4nBpYrsKyNMMRHSipliXUyoM1NyeTG9LWA6kjoP4fnI2QMgueYg565ViVfTO49AebMczzX-ZkEzsm2G5UTrQATA0ViglufvhaXNcRkLRWOzG9X51iXdjaK3qVGwWUWcMOQUXyUQIUHeXOoV-dLfur850Q0Sqe51WtcFPcyyKNmvzQI4JqfUH4rzALWuPsOJnSbti-9P~8XUKcWh4Ng__&Key-Pair-Id=APKAJBCGYQYURKHBGCOA)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/maratgaliev/dbmon. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DBMON project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/maratgaliev/dbmon/blob/master/CODE_OF_CONDUCT.md).
