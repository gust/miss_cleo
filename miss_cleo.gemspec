# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'miss_cleo/version'

Gem::Specification.new do |spec|
  spec.name          = "miss_cleo"
  spec.version       = MissCleo::VERSION
  spec.authors       = ["Dean Hu", "Lee Ourand", "John Bernier"]
  spec.email         = ["devs@gust.com"]

  spec.summary       = %q{Predict your test failures}
  spec.description   = %q{Miss Cleo frees you from having to run your full test suite to be confident in your recent code changes. Call me now!}
  spec.homepage      = "http://github.com/gust/miss_cleo"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = ["miss_cleo"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency "gzip"
end
