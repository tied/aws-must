# -*- encoding: utf-8; mode: ruby -*-

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 

# http://guides.rubygems.org/make-your-own-gem/

Gem::Specification.new do |s|
  s.name            = 'raketools'
  s.version         = File.open( "VERSION", "r" ) { |f| f.read }.strip
  s.date            = '2014-09-10'
  s.summary         = "Local helpers, namespace 'rt:'"
  s.description     = "A simple hello world rake gem"
  s.authors         = ["jj"]
  s.files           = Dir.glob("*.rake").concat( Dir.glob("lib/**/*.rb") )
  s.require_paths   = [ "lib" ]
end
