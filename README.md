# Minitest::Hyper

Generates attractive, self-contained HTML reports for your Minitest runs.

This gem was created as a demonstration of how to build a Minitest extension for [The Minitest Cookbook](http://chriskottom.com/minitestcookbook/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem "minitest-hyper", require: false
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install minitest-hyper

## Usage

To generate reports using Minitest::Hyper, you'll need to pass the `-H` or `--html` flag to Minitest on the command line in one of the usual ways.

    $ ruby -H test/foo_test.rb
    $ TEST_OPTS="--html" rake test

You can also switch on report generation globally for every test run by putting the following in your test helper:

```ruby
require "minitest/hyper"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/minitest-hyper. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

