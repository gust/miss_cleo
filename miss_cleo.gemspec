# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'miss_cleo/version'

Gem::Specification.new do |spec|
  spec.name          = "miss_cleo"
  spec.version       = MissCleo::VERSION
  spec.authors       = ["Dean Hu", "Lee Ourand", "John Bernier"]
  spec.email         = ["devs@gust.com"]

  spec.summary       = %q{Regression Test Selection}
  spec.description   = %q{Miss Cleo frees you from having to run your full test suite to be confident in your recent code changes. Call me now!}
  spec.homepage      = "http://github.com/gust/miss_cleo"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = ["miss_cleo"]
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 2.3.0'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.5.0"
  spec.add_development_dependency "pry", "~> 0.9.12"
  spec.add_development_dependency "rspec"
  spec.add_runtime_dependency "rugged", "~> 0.23.3"
  spec.add_runtime_dependency "gzip", "~> 1.0"
end
