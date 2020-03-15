# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative 'lib/herbes/version'

Gem::Specification.new do |s|
  s.name = 'herbes'
  s.version = Herbes::VERSION
  s.authors = ['haydenmcfarland']
  s.email = ['mcfarlandsms@gmail.com']
  s.date = '2020-03-12'
  s.summary = 'Simple ERB email generator for AWS Lambda'
  s.description = 'Simple ERB email generator'
  s.homepage = 'https://github.com/haydenmcfarland/herbes'
  s.license = 'MIT'
  s.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  s.require_paths = ['lib']
  s.add_dependency('nokogiri')
  s.add_dependency('premailer')
end
