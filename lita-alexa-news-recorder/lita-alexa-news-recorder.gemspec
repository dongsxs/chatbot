Gem::Specification.new do |spec|
  spec.name          = "lita-alexa-news-recorder"
  spec.required_ruby_version = '>= 2.3.0'
  spec.version       = "0.1.8"
  spec.authors       = ["Daniel J. Pritchett"]
  spec.email         = ["dpritchett@gmail.com"]
  spec.description   = "Records voice memos via Alexa and transcribes them for publishing to an Alexa Flash Briefing"
  spec.summary       = "Records voice memos via Alexa and transcribes them for publishing to an Alexa Flash Briefing"
  spec.homepage      = "https://github.com/dpritchett/lita-alexa-news-recorder"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 4.7"
  spec.add_runtime_dependency "lita-alexa-news-publisher", ">= 0.1.1"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec", ">= 3.0.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
end
