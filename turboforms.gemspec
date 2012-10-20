Gem::Specification.new do |s|
  s.name    = 'turboforms'
  s.version = '0.0.1'
  s.author  = 'Timur Vafin'
  s.email   = 'me@timurv.ru'
  s.summary = 'Turbolinks behaviour for forms'
  s.files   = Dir['lib/assets/javascripts/*.js.coffee', 'lib/turbolinks.rb', 'README.md', 'MIT-LICENSE']

  s.add_dependency 'coffee-rails'
  s.add_dependency 'turbolinks'
end