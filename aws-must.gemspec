# -*- encoding: utf-8; mode: ruby -*-

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 

# http://guides.rubygems.org/make-your-own-gem/

Gem::Specification.new do |s|

  version           = File.open( "VERSION", "r" ) { |f| f.read }.strip.gsub( "-SNAPSHOT", ".pre" )

  s.name            = 'aws-must'
  s.version         = version
  s.date            = Time.now.strftime( "%Y-%m-%d" )  #'2014-09-10'
  s.summary         = "Minimum Viable Solution to Manage CloudFormation Templates'"
  s.description     = <<EOF
aws-must is a tool, which allows separating infrastructure
configuration and Amazon related syntax using YAML and Mustache templates
EOF
  s.authors         = ["jarjuk"]
  s.files           = ["README.md"] | Dir.glob("lib/**/*") | Dir.glob( "demo/**/*" )
  s.require_paths   = [ "lib" ]
  s.executables     = [ "aws-must.rb" ]
  s.license       = 'MIT'


  s.add_dependency 'mustache',          '1.0.1'


end
