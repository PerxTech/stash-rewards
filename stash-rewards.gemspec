require_relative 'lib/stash/rewards/version'

Gem::Specification.new do |spec|
  spec.name          = 'stash-rewards'
  spec.version       = Stash::Rewards::VERSION
  spec.authors       = ['Rui Baltazar']
  spec.email         = ['rui.p.baltazar@gmail.com']

  spec.summary       = 'Gem with API wrapper for Stash Rewards'
  spec.description   = 'Helper Library to make api calls to stash rewards'
  spec.homepage      = 'https://github.com/PerxTech/stash-rewards'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/PerxTech/stash-rewards'
  spec.metadata['changelog_uri'] = 'https://github.com/PerxTech/stash-rewards/blob/main/README.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'faraday', '~> 1'

  spec.add_development_dependency 'rspec'
end
