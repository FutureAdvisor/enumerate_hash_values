# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "enumerate_hash_values/version"

Gem::Specification.new do |s|
  s.name        = "enumerate_hash_values"
  s.version     = EnumerateHashValues::VERSION
  s.authors     = ["FutureAdvisor"]
  s.email       = ["core.platform@futureadvisor.com"]
  s.homepage    = %q{http://github.com/FutureAdvisor/enumerate_hash_values}
  s.summary     = %q{Defines higher-order functions available in Enumerable that work over a Hash's values and return a Hash.}
  s.description = %q{Defines higher-order functions available in Enumerable that work over a Hash's values and return a Hash.}
  s.license     = 'MIT'

  s.rubyforge_project = "enumerate_hash_values"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
