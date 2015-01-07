Gem::Specification.new do |s|
  s.name        = 'fanout'
  s.version     = '1.1.0'
  s.date        = '2015-01-06'
  s.summary     = 'Fanout.io library for Ruby'
  s.description = 'A Ruby convenience library for publishing messages to Fanout.io using the EPCP protocol'
  s.authors     = ['Konstantin Bokarius']
  s.email       = 'bokarius@comcast.net'
  s.files       = ['lib/fanout.rb', 'lib/jsonobjectformat.rb']
  s.homepage    = 'http://rubygems.org/gems/fanout'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 1.9.0'
  s.add_runtime_dependency 'pubcontrol', '~> 1'
end
