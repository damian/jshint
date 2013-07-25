# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jshint/version'

Gem::Specification.new do |spec|
  spec.name          = "jshint"
  spec.version       = Jshint::VERSION
  spec.authors       = ["Damian Nicholson"]
  spec.email         = ["damian.nicholson21@gmail.com"]
  spec.description   = %q{Ensures your JavaScript code adheres to best practices}
  spec.summary       = %q{Ensures your JavaScript code adheres to best practices}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "therubyracer", "~> 0.10.2"
  spec.add_dependency "execjs", "~> 1.4.0"
  spec.add_dependency "railties", ">= 3.2.0"
  spec.add_dependency 'multi_json', '~> 1.0'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "yard"
end
