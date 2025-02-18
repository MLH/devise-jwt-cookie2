# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'devise/jwt/cookie/version'

Gem::Specification.new do |spec|
  spec.name          = 'devise-jwt-cookie'
  spec.version       = Devise::JWT::Cookie::VERSION
  spec.authors       = ['Niels van der Zanden', 'Major League Hacking']
  spec.email         = ['niels@pharynx.nl', 'hi@mlh.io']

  spec.summary       = 'Cookie-based JWT authentication for devise'
  spec.description   = 'Cookie-based JWT authentication for devise with configurable token revocation strategies'
  spec.homepage      = 'https://github.com/mlh/devise-jwt-cookie'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.7.0'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(/^(test|spec|features)\//)
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(/^exe\//) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'devise-jwt', '~> 0.10'
  spec.add_dependency 'dry-auto_inject', '~> 1.0'
  spec.add_dependency 'dry-configurable', '~> 1.0'

  spec.add_development_dependency 'bundler', '> 1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec'
  # Needed to test the rails fixture application
  spec.add_development_dependency 'rails', '~> 7.0'
  spec.add_development_dependency 'rspec-rails', '~> 4.0'
  spec.add_development_dependency 'sqlite3', '~> 2.0'
  # Cops
  spec.add_development_dependency 'mlh-rubocop-config'
  spec.add_development_dependency 'rubocop', '~> 1.0'
  # Test reporting
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 1.0'
  spec.add_development_dependency 'simplecov', '0.17'
end
