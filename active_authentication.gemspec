require_relative "lib/active_authentication/version"

Gem::Specification.new do |spec|
  spec.name = "active_authentication"
  spec.version = ActiveAuthentication::VERSION
  spec.authors = ["Patricio Mac Adden"]
  spec.email = ["patriciomacadden@gmail.com"]
  spec.homepage = "https://github.com/sinaptia/active_authentication"
  spec.summary = "A pure Rails authentication solution"
  spec.description = "A pure Rails authentication solution. Inspired by devise, but with a pure Rails implementation."

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.licenses = ["MIT"]

  spec.add_dependency "rails", "~> 7.0"
  spec.add_dependency "bcrypt", "~> 3.1"
end
