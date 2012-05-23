# -*- encoding: utf-8 -*-
require File.expand_path('../lib/github_pulls/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["HORII Keima"]
  gem.email         = ["holy@aiming-inc.com"]
  gem.description   = %q{Library to get github pull requests}
  gem.summary       = %q{Only to get github pull requests}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "github_pulls"
  gem.require_paths = ["lib"]
  gem.version       = GithubPulls::VERSION

  gem.add_development_dependency('rspec')
end
