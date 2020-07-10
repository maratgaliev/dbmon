lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dbmon/version"

Gem::Specification.new do |spec|
  spec.name          = "dbmon"
  spec.version       = Dbmon::VERSION
  spec.authors       = ["Marat Galiev"]
  spec.email         = ["kazanlug@gmail.com"]

  spec.summary       = "Summary"
  spec.description   = "Long"
  spec.homepage      = "http://maratgaliev.com"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/maratgaliev/dbmon.git"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency "ruby-pg-extras"
end
