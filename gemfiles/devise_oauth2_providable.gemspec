# -*- encoding: utf-8 -*-

# Gemika requires
'../lib/devise/oauth2_providable/version.rb'.tap do |path|
  if File.exist?(f = File.expand_path(path, __FILE__))
    require f
  else
    require File.expand_path("../#{path}", __FILE__)
  end
end

Gem::Specification.new do |s|
  s.name        = 'devise_oauth2_providable'
  s.version     = Devise::Oauth2Providable::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Ryan Sonnek']
  s.email       = ['ryan@socialcast.com']
  s.homepage    = ''
  s.summary     = 'OAuth2 Provider for Rails3 applications'
  s.description = 'Rails3 engine that adds OAuth2 Provider support to any application built with Devise authentication'

  s.add_runtime_dependency('rails', ['>= 4.2.0'])
  s.add_runtime_dependency('devise', ['>= 1.4.3'])
  s.add_runtime_dependency('rack-oauth2', ['>= 0.11.0'])
  s.add_development_dependency('rspec-rails', ['>= 2.6'])
  s.add_development_dependency('sqlite3', ['~> 1.3'])
  s.add_development_dependency('shoulda-matchers')
  s.add_development_dependency('pry', ['~> 0.9.6'])
  s.add_development_dependency('factory_girl', ['~> 2.2'])
  s.add_development_dependency('factory_girl_rspec', ['~> 0.0.1'])
  s.add_development_dependency('rake', ['~> 0.9.2'])

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map(&File.method(:basename))
  s.require_paths = ['lib']
end
