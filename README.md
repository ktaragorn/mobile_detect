mobile-detect
=============
![Build probably passing](https://travis-ci.org/ktaragorn/mobile_detect.svg?branch=master)
[![Gem Version](https://badge.fury.io/rb/mobile-detect.svg)](https://badge.fury.io/rb/mobile-detect)

This is a ruby version of a [php library of the same name](https://github.com/serbanghita/Mobile-Detect). It uses the exported data provided by that library and hopes to implement a significant subset of the features.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mobile-detect'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mobile-detect

## Usage

```ruby
# First argument is a hash of HTTP headers by the requesting device
# Second argument is the User Agent string
device = MobileDetect.new({
  'HTTP_USER_AGENT': 'Mozilla/5.0 (iPhone; CPU iPhone OS 6_0_1 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A523 Safari/8536.25',
  'HTTP_ACCEPT': 'text/vnd.wap.wml, application/json, text/javascript, */*; q=0.01',
  'HTTP_ACCEPT_LANGUAGE': 'en-us,en;q=0.5',
  'HTTP_ACCEPT_ENCODING': 'gzip, deflate'
}, 'Mozilla/5.0 (BlackBerry; U; BlackBerry 9700; en-US) AppleWebKit/534.8  (KHTML, like Gecko) Version/6.0.0.448 Mobile Safari/534.8')

device.mobile?
# => true
device.tablet?
# => false
device.is? 'blackberry'
# => true
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.
