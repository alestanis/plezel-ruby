# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'plezel/version'

Gem::Specification.new do |spec|
  spec.name          = "plezel-ruby"
  spec.version       = Plezel::VERSION
  spec.authors       = ["alejandra"]
  spec.email         = ["ale.estanislao@gmail.com"]
  spec.description   = "Ruby binder for the Plezel API."
  spec.summary       = "Ruby binder for the Plezel API."
  spec.homepage      = "https://github.com/alestanis/plezel-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'json'
  spec.add_dependency 'rest-client'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
end
