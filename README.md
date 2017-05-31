# VgApi

This is provider for VainGlory api https://developer.vainglorygame.com.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vg_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vg_api

## Rails integration

Add this line to your application's Gemfile:

```ruby
gem 'vg_api'
```

And then execute:

    $ bundle

Create vg_api_config.yml file into config dir.

```yml
VG_ACCESS_TOKEN: your_access_token
```

## Get player stat

```ruby
VgApi::Player.find_by_name('name', 'region')
```

## TO DO
1. Get Players matches
2. Parse matches stat and convert to normal wrapper
