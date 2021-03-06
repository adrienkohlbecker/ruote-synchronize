# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruote/synchronize/version'

Gem::Specification.new do |spec|
  spec.name          = "ruote-synchronize"
  spec.version       = Ruote::Synchronize::VERSION
  spec.authors       = ["Adrien Kohlbecker"]
  spec.email         = ["adrien.kohlbecker@gmail.com"]
  spec.description   = %q{A process synchronisation module for Ruote.}
  spec.summary       = %q{A process synchronisation module for Ruote.
                        Will define a synchronize :key => "my_unique_key" participant.
                        You can use it in two processes by defining the same synchronisation key.
                        The first process to reach the synchronization will wait for the other one.}.gsub(/^\s+/, '')

  spec.homepage      = "https://github.com/adrienkohlbecker/ruote-synchronize"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "ruote"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'mutant'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'redcarpet'
end
