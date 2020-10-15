Gem::Specification.new do |spec|
  spec.name          = "lita-cleverbot-demo"
  spec.version       = "0.1.0"
  spec.authors       = ["Daniel J. Pritchett"]
  spec.email         = ["dpritchett@gmail.com"]
  spec.description   = "Help your Lita chatbot ask Cleverbot when she runs out of things to say."
  spec.summary       = "Help your Lita chatbot ask Cleverbot when she runs out of things to say."
  spec.homepage      = "https://github.com/dpritchett/lita-cleverbot-demo"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 4.7"
  spec.add_dependency "cleverbot_io"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec", ">= 3.0.0"
end
