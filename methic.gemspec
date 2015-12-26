# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "methic"
  spec.version       = '0.0.1'
  spec.authors       = ["Josef Šimánek"]
  spec.email         = ["josef.simanek@gmail.com"]
  spec.summary       = %q{Simple arithmetic implemented by Canopy.}
  spec.homepage      = "https://github.com/simi/methican"
  spec.license       = "MIT"

  spec.files         = ['methic.rb', 'methic_parser.rb', 'methic_test.rb']
  spec.test_files    = ['methic_test.rb']
  spec.require_paths = ["."]

  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake"
end
