# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hulk/version'

Gem::Specification.new do |spec|
  spec.name          = "the_hulk"
  spec.version       = Hulk::VERSION
  spec.authors       = ["Ethan Welborn"]
  spec.email         = ["welborn.ethan@gmail.com"]
  spec.summary       = %q{Super simple, super strong command runner.}
  spec.description   = %q{Hulk takes a .yml file with sets of commands that it can run sequentially.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ['hulk']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
