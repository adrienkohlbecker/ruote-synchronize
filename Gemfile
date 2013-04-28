source 'https://rubygems.org'

# Specify your gem's dependencies in ruote-broker.gemspec
gemspec

platforms :ruby_18, :jruby do
  gem 'json' unless RUBY_VERSION > '1.9' # is there a jruby but 1.8 only selector?
end

group :test do
  gem 'rake'
  gem 'rspec'
  gem 'coveralls', :require => false
end
