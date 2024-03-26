require_relative "lib/pauth/version"

Gem::Specification.new do |spec|
  spec.name = "pauth"
  spec.version = Pauth::VERSION
  spec.authors = ["Patricio Mac Adden"]
  spec.email = ["patriciomacadden@gmail.com"]
  spec.homepage = "https://github.com/patriciomacadden/pauth"
  spec.summary = "Patricio's Authentication"
  spec.description = "Patricio's Authentication"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.1.3.2"
  spec.add_dependency "bcrypt", "~> 3.1"
end
