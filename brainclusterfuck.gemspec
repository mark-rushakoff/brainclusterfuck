# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'brainclusterfuck/version'

Gem::Specification.new do |spec|
  spec.name          = "brainclusterfuck"
  spec.version       = Brainclusterfuck::VERSION
  spec.authors       = ["Mark Rushakoff"]
  spec.email         = ["mark.rushakoff@gmail.com"]
  spec.description   = %q{Provides a clean interface to arrays of Brainfuck VMs, primarily to use for asynchronous processing.}
  spec.summary       = %q{Clean API to arrays of Brainfuck VMs}
  spec.homepage      = "http://github.com/mark-rushakoff/brainclusterfuck"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.13"
end
