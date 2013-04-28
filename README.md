[![Build Status](https://travis-ci.org/adrienkohlbecker/ruote-synchronize.png)](https://travis-ci.org/adrienkohlbecker/ruote-synchronize) [![Coverage Status](https://coveralls.io/repos/adrienkohlbecker/ruote-synchronize/badge.png?branch=master)](https://coveralls.io/r/adrienkohlbecker/ruote-synchronize) [![Code Climate](https://codeclimate.com/github/adrienkohlbecker/ruote-synchronize.png)](https://codeclimate.com/github/adrienkohlbecker/ruote-synchronize) [![Dependency Status](https://gemnasium.com/adrienkohlbecker/ruote-synchronize.png)](https://gemnasium.com/adrienkohlbecker/ruote-synchronize)

# Ruote::Synchronize

- **Homepage**: [github.com/adrienkohlbecker/ruote-synchronize](https://github.com/adrienkohlbecker/ruote-synchronize)
- **Rdoc**: [rdoc.info/gems/ruote-synchronize](http://rdoc.info/gems/ruote-synchronize)
- **Author**: Adrien Kohlbecker
- **License**: MIT License
- **Latest Version**: 0.1.0 (unreleased)
- **Release Date**: none

## Synopsis

A process synchronisation module for Ruote.

Will define a `synchronize :key => "my_unique_key"` participant.
You can use it in two processes by defining the same synchronisation key.
The first process to reach the synchronization will wait for the other one.

## Usage

```ruby

# Charly and Doug will only run when both Alice and Bob have run,
# no matter which one of Alice or Bob finishes first

Ruote::Synchronize.setup(engine)

pdef1 = Ruote.process_definition do
  alice
  synchronize :key => 'my_very_unique_key'
  charly
end

pdef2 = Ruote.process_definition do
  bob
  synchronize :key => 'my_very_unique_key'
  doug
end
```

It works by storing the first workitem along with the key.
When the second process reaches synchronize, it will find the previous workitem,
receive it (allowing the first process to proceed), and reply immediately.

You must use a key that you know will NEVER be used outside of the two process you want to synchronize.

**Pay attention to multiple launches** (if your process is launched by an HTTP request for example).
If three processes with the same key are launched, the two first will be synchronized and the last one will be left hanging.

## Requirements

A functionall installation of [Ruote](http://ruote.rubyforge.org) is needed.

ruote-synchronize has been tested on Ruby 1.8+.

## Installation

Add this line to your application's Gemfile:

    gem 'ruote-synchronize'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruote-synchronize

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Run the tests (`bundle exec rspec`)
6. Create new Pull Request
