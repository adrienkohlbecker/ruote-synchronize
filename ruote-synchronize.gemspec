# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruote/synchronize/version'

Gem::Specification.new do |spec|
  spec.name          = "ruote-synchronize"
  spec.version       = Ruote::Synchronize::VERSION
  spec.authors       = ["Adrien Kohlbecker"]
  spec.email         = ["adrien.kohlbecker@gmail.com"]
  spec.description   = %q{Ruote 1-1 process synchronization}
  spec.summary       = %q{Ruote 1-1 process synchronization}
  spec.homepage      = "https://github.com/adrienkohlbecker/ruote-synchronize"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.requirements << 'ruote'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'mutant'
end
