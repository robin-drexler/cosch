Gem::Specification.new do |s|
  s.name        = 'cosch'
  s.version     = '1.0.0'
  s.date        = '2014-10-10'
  s.summary     = ""
  s.description = ""
  s.authors     = ["Robin Drexler"]

  all_files       = `git ls-files -z`.split("\x0")
  s.files         = all_files.grep(%r{^(bin|lib)/})
  s.executables   = all_files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.email       = 'drexler.robin@gmail.com'
  s.license       = 'MIT'


  s.add_runtime_dependency('liquid',    "~> 2.6.1")
  s.add_runtime_dependency('mercenary', "~> 0.3.4")

  s.add_development_dependency('sass', "~> 3.4.4")
  s.add_development_dependency('rspec', "~> 3.1.0")
  s.add_development_dependency('nokogiri', "~> 1.6.3.1")
end