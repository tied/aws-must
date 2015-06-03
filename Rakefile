# -*- mode: ruby -*-

# ------------------------------------------------------------------
# default


task :default => [:usage]

# ------------------------------------------------------------------
# Internal development

begin

  require "raketools_site.rb"
rescue LoadError
  # puts ">>>>> Raketools not loaded, omitting tasks"
end


# ------------------------------------------------------------------
# demo

namespace "demo" do |ns|

  # --------------------
  # Demo configs

  cmd="bin/aws-must.rb"                # generator being demonstrated
  demo_dir="demo"                      # directory holding demo configs
  stack="demo"                         # name of the on Amazon

  [ 

   { :id => "1", :desc=>"Initial copy", :region=>['eu-central-1'] },
   { :id => "2", :desc=>"Added 'description' -property to YAML file", :region=>['eu-central-1']  },
   { :id => "3", :desc=>"Use resources.mustache -partial to create EC2 intance", :region=>['eu-central-1']   },
   { :id => "4", :desc=>"EC2 instance configuration using YAML-data", :region=>['eu-central-1']   },
   { :id => "5", :desc=>"Add 'Outputs' -section with reference to EC2 instance", :region=>['eu-central-1']   },
   { :id => "6", :desc=>"Add 'Inputs' and 'Mappings' -sections to parametirize", :region=>["ap-northeast-1", "ap-southeast-1", "ap-southeast-2", "cn-north-1", "eu-central-1", "eu-west-1", "sa-east-1", "us-east-1", "us-gov-west-1", "us-west-1", "us-west-2"]   }




  ].each do  |c|

    desc "Output CF template using configs in '#{demo_dir}/#{c[:id]}' to demonstrate '#{c[:desc]}'"
    task "template-#{c[:id]}" do
      sh "#{cmd} gen -t #{demo_dir}/#{c[:id]} #{demo_dir}/#{c[:id]}/conf.yaml"
    end

    desc "Check the difference between version '#{c[:id]}' and '#{c[:id].to_i() -1}' "
    task "diff-#{c[:id]}" do
      prev = c[:id].to_i() -1
      # use bash temporary names pipes to diff two stdouts
      # Use `jq` to create canonical pretty print json
      sh "bash -c \"diff <(#{cmd} gen -t #{demo_dir}/#{c[:id]} #{demo_dir}/#{c[:id]}/conf.yaml | jq . ) <(#{cmd} gen -t #{demo_dir}/#{prev} #{demo_dir}/#{prev}/conf.yaml | jq . ) || true \""
    end

    desc "Create stack #{stack} for '#{demo_dir}/#{c[:id]}' supported regions=#{c[:region]}"
    task "stack-#{c[:id]}" do
      sh "aws cloudformation create-stack --stack-name #{stack}  --template-body \"$(#{cmd} gen -t #{demo_dir}/#{c[:id]} #{demo_dir}/#{c[:id]}/conf.yaml)\""
    end
    

  end

  desc "Show status of CloudFormation stack"
  task "stack-status" do
    sh "aws cloudformation describe-stacks"
  end

  desc "Show events of CloudFormation stack '#{stack}'"
  task "stack-events" do
    sh "aws cloudformation describe-stack-events --stack-name #{stack}"
  end

  desc "Delete stack CloudFormation stack '#{stack}'"
  task "stack-delete" do
    sh "aws cloudformation delete-stack --stack-name #{stack}"
  end


end

# ------------------------------------------------------------------
# dev

namespace "dev" do |ns|


  desc "Run rspec for spec -directory (with optional params)"
  task :rspec, :rspec_opts  do |t, args|
    args.with_defaults(:rspec_opts => "")
    sh "bundle exec rspec --format documentation #{args.rspec_opts} spec"
  end

end

# ------------------------------------------------------------------
# usage 

desc "list tasks"
task :usage do
  puts "Tasks: #{(Rake::Task.tasks - [Rake::Task[:usage]]).join(', ')}"
  puts "(type rake -T for more detail)\n\n"
end
