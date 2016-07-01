# -*- encoding: utf-8 -*-

Gem::Specification.new do |spec|
  spec.name = 'pvwatts'
  spec.version = '1.0.0.beta'

  spec.authors = [
    'Matt Aimonetti',
    'Kyle Ries'
  ]
  spec.description = 'Calculates the Performance of a Grid-Connected PV System.'
  spec.email = 'kyle.ries@gmail.com'
  spec.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  spec.files = `git ls-files`.split("\n")
  spec.homepage = 'http://github.com/mattetti/pvwatts'
  spec.licenses = ["MIT"]
  spec.require_paths = ["lib"]
  spec.summary = 'Wrapper around the https://developer.nrel.gov/docs/solar/pvwatts-v5/ web service API.'
  spec.test_files = [
    "spec/pvwatts_spec.rb",
    "spec/spec_helper.rb"
  ]

  spec.add_dependency 'virtus'
  spec.add_dependency 'addressable'
  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake',    '~> 11.2.2'
  spec.add_development_dependency 'rspec',   '~> 3.4.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
