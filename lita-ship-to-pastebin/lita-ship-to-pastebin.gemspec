Gem::Specification.new do |spec|
  spec.name          = 'lita-ship-to-pastebin'
  spec.version       = '0.1.6'
  spec.authors       = ['Daniel J. Pritchett']
  spec.email         = ['dpritchett@gmail.com']
  spec.description   = 'Expose helper method to pastebin-ify any input text'
  spec.summary       = 'Expose helper method to pastebin-ify any input text'
  spec.homepage      = 'https://github.com/dpritchett/lita-ship-to-pastebin'
  spec.license       = 'MIT'
  spec.metadata      = { 'lita_plugin_type' => 'extension' }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'lita', '>= 4.7'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rspec', '>= 3.0.0'

  spec.add_development_dependency 'webmock', '~> 3.3'
end
