# frozen_string_literal: true

require_relative "lib/magic_bus/version"

Gem::Specification.new do |spec|
  spec.name          = "magic_bus"
  spec.version       = MagicBus::VERSION
  spec.authors       = ["Russell Edens"]
  spec.email         = ["rx@evvnt.com"]

  spec.summary       = "magic_bus gem"
  spec.description   = "This gem drives the (magic) Event Bus between two applications."
  spec.homepage      = "https://github.com/evvnt/magic_bus"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7.6"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/evvnt/magic_bus"
  spec.metadata["changelog_uri"] = "https://github.com/evvnt/magic_bus/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "shoryuken", "~>6.2.0"
  spec.add_dependency "aws-sdk-sns", "~>1.80.0"
  spec.add_dependency "aws-sdk-sqs", "~>1.80.0"

  spec.add_development_dependency "activerecord", ">=5.2"
  spec.add_development_dependency "railties", ">=5.2"
  spec.add_development_dependency "rubocop", ">=1.25"
  spec.add_development_dependency "sqlite3-ruby", ">=1.3"
  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end
