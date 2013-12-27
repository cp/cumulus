# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cumulus/version'

Gem::Specification.new do |spec|
  spec.name          = "cumulus"
  spec.version       = Cumulus::VERSION
  spec.authors       = ["Colby Aley"]
  spec.email         = ["colby@aley.me"]
  spec.description   = %q{Access the Cloudability API through the command line}
  spec.summary       = %q{Access the Cloudability API through the command line}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "cloudability"
  spec.add_runtime_dependency "netrc"
  spec.add_runtime_dependency "thor"
  spec.add_runtime_dependency "terminal-table"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
