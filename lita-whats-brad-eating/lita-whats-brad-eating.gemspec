Gem::Specification.new do |spec|
  spec.name          = 'lita-whats-brad-eating'
  spec.version       = '1.0.1'
  spec.authors       = ['Daniel J. Pritchett']
  spec.email         = ['dpritchett@gmail.com']
  spec.description   = "show brad's food"
  spec.summary       = "show brad's food"
  spec.homepage      = 'http://dpritchett.net'
  spec.license       = 'MIT'
  spec.metadata      = { 'lita_plugin_type' => 'handler' }

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'lita', '>= 4.7'
  spec.add_dependency 'nokogiri'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rspec', '>= 3.0.0'
  spec.add_development_dependency 'vcr', '~> 3.0.3'
  spec.add_development_dependency 'coveralls', '~> 0.8.20'
  spec.add_development_dependency 'faraday', '~> 0.11.0'
end
