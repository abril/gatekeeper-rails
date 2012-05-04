# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'gatekeeper'

Gem::Specification.new do |s|
  s.name        = "gatekeeper-rails"
  s.version     = Gatekeeper::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Eric Fer", "Lucas Fais"]
  s.email       = ["eric.fer@gmail.com", "lucasfais@gmail.com"]
  s.homepage    = "https://github.com/abril/gatekeeper-rails"
  s.summary     = %q{Simple DSL for authorization with Rails}
  s.description = %q{gatekeeper-rails provides a simple and 
    beaultiful DSL to do authorization checks in rails controllers}

  s.required_rubygems_version = ">= 1.3.6"
  s.add_dependency "rails", '>= 2.1.0'
  
  s.add_development_dependency "step-up"
  s.add_development_dependency "rails", '~> 3.1.0'

  excepts = %w[
    .gitignore
    gatekeeper-rails.gemspec
  ]
  
  tests = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.files = `git ls-files`.split("\n") - excepts - tests
  s.test_files = tests
  s.require_paths = ["lib"]
end