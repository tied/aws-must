# -*- mode: ruby -*-

# ------------------------------------------------------------------
# default


task :default => [:usage]

# ------------------------------------------------------------------
# Internal development

begin

  require "raketools_site.rb"
  require "raketools_release.rb"
rescue LoadError
  # puts ">>>>> Raketools not loaded, omitting tasks"
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



end

# ------------------------------------------------------------------
# usage 

desc "list tasks"
task :usage do
  puts "Tasks: #{(Rake::Task.tasks - [Rake::Task[:usage]]).join(', ')}"
  puts "(type rake -T for more detail)\n\n"
end
