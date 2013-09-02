Gem::Specification.new do |s|
  s.name        = 'riyic'
  s.version     = '0.1.0'
  s.date        = '2013-07-03'
  s.summary     = "Tool to test riyic server configurations"
  s.description = "Riyic is a server configuration service based on chef (http://riyic.com). The riyic_node gem is a tool to test your riyic server configurations"
  s.authors     = ["Javier Gomez"]
  s.email       = 'alambike@gmail.com'
  s.require_paths = ["lib"]
  s.files         = `git ls-files`.split($/)

  s.add_runtime_dependency "oj","~> 2.0"
  s.add_runtime_dependency "net-ssh","~> 2.6"
  s.add_runtime_dependency "mixlib-shellout","~> 1.1"
  
  # necesitamos a nosa gema de digital_ocean
  #s.add_runtime_dependency "do_api","~> 0.1"

  s.homepage    =
    'https://github.com/RIYIC/riyic_node'
end
