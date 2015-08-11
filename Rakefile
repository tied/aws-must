# -*- mode: ruby -*-

require "stringio"

# ------------------------------------------------------------------
# default


task :default => [:usage]

# ------------------------------------------------------------------
# configs

demo_dir          = "demo"
generate_docs_dir = "generated-docs"


# ------------------------------------------------------------------
# Internal development

begin

  require "raketools_site.rb"
  require "raketools_release.rb"
rescue LoadError
  # puts ">>>>> Raketools not loaded, omitting tasks"
end


def version() 
  # gemspec wants to use 'pre' and not '-SNAPSHOT'
  return File.open( "VERSION", "r" ) { |f| f.read }.strip.gsub( "-SNAPSHOT", ".pre" )   # version number from file
end

# ------------------------------------------------------------------
# Manage keys

keyname = "demo-key"                                              
key_file = "~/.ssh/demo-key/demo-key.pub"   

desc "Initialize aws environment: import public key #{keyname} from #{key_file}"
task "key-init" do
  sh "aws ec2 import-key-pair --key-name #{keyname} --public-key-material \"$(cat #{key_file})\""
end

desc "Clear aws environment: delete public key #{keyname} from #{key_file}"
task "stack-clear" do
  sh "aws ec2 delete-key-pair --key-name #{keyname}"
end



# ------------------------------------------------------------------
# demo

import "./lib/tasks/demo.rake"

# ------------------------------------------------------------------
# dev

namespace "dev" do |ns|


  desc "Run rspec for spec -directory (with optional params)"
  task :rspec, :rspec_opts  do |t, args|
    args.with_defaults(:rspec_opts => "")
    sh "bundle exec rspec --format documentation #{args.rspec_opts} spec"
  end

  desc "Launch guard"
  task :guard do
    sh "bundle exec guard"
  end

  desc "Build gempspec"
  task :build do
    sh "gem build aws-must.gemspec"
  end

  desc "Install locally"
  task :install do
    version = version()
    sh "gem install ./aws-must-#{version}.gem"
  end

  desc "Push to RubyGems"
  task :push do
    version = version()
    sh "gem push ./aws-must-#{version}.gem"
  end

  desc "Generate docs for demo into `{generate_docs_dir}` -subdirectory"
  task :docs do
    Dir.foreach(demo_dir) do |item|

      next if item == '.' or item == '..'
      raketask = "demo:doc-#{item}"
      if File.directory?("#{demo_dir}/#{item}") and  Rake::Task.task_defined?( raketask ) then
        file = "#{generate_docs_dir}/#{item}.html"
        capture_stdout_to( file )  { Rake::Task[raketask].invoke  }
      end
    end
  end


  desc "Unit test, create demo html documents, release, create gem, install gem locally, snapshot"
  task "full-delivery" => [ "dev:rspec", "dev:docs", "rt:release", "rt:push", "dev:build", "dev:install", "rt:snapshot" ]


end

# ------------------------------------------------------------------
# common methods

def capture_stdout_to( file )
  real_stdout, = $stdout.clone
  $stdout.reopen( file )
  $stdout.sync = true
  yield
  # $stdout.string
ensure
  $stdout.reopen( real_stdout )
  $stdout.sync = true

end

# ------------------------------------------------------------------
# usage 

desc "list tasks"
task :usage do
  puts "Tasks: #{(Rake::Task.tasks - [Rake::Task[:usage]]).join(', ')}"
  puts "(type rake -T for more detail)\n\n"
end
