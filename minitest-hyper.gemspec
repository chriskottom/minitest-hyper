# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'minitest/hyper_plugin'

Gem::Specification.new do |spec|
  spec.name          = "minitest-hyper"
  spec.version       = Minitest::Hyper::VERSION
  spec.authors       = ["Chris Kottom"]
  spec.email         = ["chris@chriskottom.com"]

  spec.summary       = "Pretty HTML reports for Minitest"
  spec.description   = "Generate attractive, single-page HTML reports for your Minitest runs"
  spec.homepage      = "https://github.com/chriskottom/minitest-hyper"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.8"
end
