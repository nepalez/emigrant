Gem::Specification.new do |gem|
  gem.name     = "emigrant"
  gem.version  = "0.0.1"
  gem.author   = "Andrew Kozin (nepalez)"
  gem.email    = "andrew.kozin@gmail.com"
  gem.homepage = "https://github.com/tram/tram-policy"
  gem.summary  = "Standalone multi-language migrator"
  gem.license  = "MIT"

  gem.files            = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.test_files       = gem.files.grep(/^spec/)
  gem.extra_rdoc_files = Dir["README.md", "LICENSE", "CHANGELOG.md"]

  gem.required_ruby_version = ">= 2.2"

  gem.add_development_dependency "rspec", "~> 3.0"
  gem.add_development_dependency "rspec-its", "~> 1.2"
  gem.add_development_dependency "rake", "> 10"
  gem.add_development_dependency "rubocop", "~> 0.42"
  gem.add_development_dependency "thor", "~> 0.19"
  gem.add_development_dependency "factory_girl", "~> 4.8"
end
