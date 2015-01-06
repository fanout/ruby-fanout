Gem::Specification.new do |s|
  s.name        = 'fanout'
  s.version     = '0.0.8'
  s.date        = '2015-01-06'
  s.summary     = 'Fanout.io library for Ruby'
  s.description = 'A Ruby convenience library for publishing FPP format messages to Fanout.io using the EPCP protocol'
  s.authors     = ['Konstantin Bokarius']
  s.email       = 'bokarius@comcast.net'
  s.files       = ['lib/fanout.rb', 'lib/fppformat.rb']
  s.homepage    = 'http://rubygems.org/gems/fanout'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 1.9.0'
  s.add_runtime_dependency 'pubcontrol', '~> 0'
end
