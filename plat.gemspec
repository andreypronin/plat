# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'plat/version'

Gem::Specification.new do |spec|
  spec.name          = 'plat'
  spec.version       = Plat::VERSION
  spec.authors       = ['moonfly (Andrey Pronin)']
  spec.email         = ['moonfly.msk@gmail.com']
  spec.summary       = %q{DevOps platform management}
  spec.description   = %q{Makes most deployment headaches go away and greatly speeds up the initial phase of a new app development.}
  spec.homepage      = 'https://github.com/moonfly/plat'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  
  spec.rdoc_options = ['--charset=UTF-8']
  spec.extra_rdoc_files = %w[README.md CONTRIBUTORS.md LICENSE.txt]
  
  spec.add_dependency 'fog', '~> 1.23.0'

  spec.add_development_dependency 'bundler', '>= 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'coveralls'
  # spec.add_development_dependency 'codeclimate-test-reporter', '~> 0.3.0'
end
