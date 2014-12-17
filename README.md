# JSHint

[![travis-ci](https://api.travis-ci.org/damian/jshint.png)](http://travis-ci.org/#!/damian/jshint)
[![Code Climate](https://codeclimate.com/github/damian/jshint.png)](https://codeclimate.com/github/damian/jshint)
[![Coverage Status](https://coveralls.io/repos/damian/jshint/badge.png?branch=master)](https://coveralls.io/r/damian/jshint?branch=master)

Making it easy to lint your JavaScript assets in any Rails 3.1+ application.

## Installation

Add this line to your application's Gemfile:

```ruby
group :development, :test do
  gem 'jshint'
end
```

And then execute:

```ruby
$ bundle
```

Run the generator:

```ruby
bundle exec rake jshint:install_config
```

## Usage

To start using JSHint simply run the Rake task:

```ruby
bundle exec rake jshint
```

This Rake task runs JSHint across all the JavaScript assets within the following three folders to ensure that they're lint free. Using that data it builds a report which is shown in STDOUT.

```bash
your-rails-project/app/assets/javascripts
your-rails-project/vendor/assets/javascripts
your-rails-project/lib/assets/javascripts
```

## Configuration

JSHint has some configuration options. You can read the default configuration created by JSHint in your applications config folder.

```yaml
# your-rails-project/config/jshint.yml
files: ['**/*.js']
exclude_paths: []
options:
  boss: true
  browser: true
  ...
  globals:
    jQuery: true
    $: true
```

To exclude the vendor javascripts directory, add this line to your config file. There is currently no way to exclude a single file.
````yaml
exclude_paths: ['vendor/assets/javascripts']
````

For more configuration options see the [JSHint documentation](http://jshint.com/docs/options/).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

