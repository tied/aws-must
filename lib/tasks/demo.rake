# -*- mode: ruby -*-

# Thank You!
# http://andyatkinson.com/blog/2014/06/23/sharing-rake-tasks-in-gems

# demo.rake

require 'json'

namespace "demo" do |ns|

  # --------------------
  # Demo configs

  cmd="bin/aws-must.rb"                # generator being demonstrated
  demo_dir="demo"                      # directory holding demo configs
  stack="demo"                         # name of the on Amazon

  all_regions= ["ap-northeast-1", "ap-southeast-1", "ap-southeast-2", "cn-north-1", "eu-central-1", "eu-west-1", "sa-east-1", "us-east-1", "us-gov-west-1", "us-west-1", "us-west-2"] 

  [ 

   { :id => "1", :desc=>"Initial copy", :region=>['eu-central-1'] },
   { :id => "2", :desc=>"Added 'description' -property to YAML file", :region=>['eu-central-1']  },
   { :id => "3", :desc=>"Use resources.mustache -partial to create EC2 intance", :region=>['eu-central-1']   },
   { :id => "4", :desc=>"EC2 instance configuration using YAML-data", :region=>['eu-central-1']   },
   { :id => "5", :desc=>"Add 'Outputs' -section with reference to EC2 instance", :region=>['eu-central-1']   },
   { :id => "6", :desc=>"Add 'Inputs' and 'Mappings' -sections to parametirize", :region=> all_regions },
   { :id => "7", :desc=>"Added support for input parameters, EC2 tags, Instance security group", :region=>all_regions },


  ].each do  |c|

    desc "Output CF template using configs in '#{demo_dir}/#{c[:id]}' to demonstrate '#{c[:desc]}'"
    task "template-#{c[:id]}" do
      sh "#{cmd} gen -t #{demo_dir}/#{c[:id]} #{demo_dir}/#{c[:id]}/conf.yaml"
    end

    desc "Output configs in '#{demo_dir}/#{c[:id]}' in JSON to demonstrate '#{c[:desc]}'"
    task "json-#{c[:id]}" do
      sh "#{cmd} json #{demo_dir}/#{c[:id]}/conf.yaml"
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

  desc "Ssh connection"
  task 'stack-ssh', :instanceName  do |t, args|
    raise "Task '#{t}' usage: #{t}[instanceName] - exiting"  if args.instanceName.nil?
    stack = %x{ aws cloudformation describe-stacks --stack-name #{stack} }
    raise "Error #{$?.exitstatus}" if $?.exitstatus != 0
    stack_json = JSON.parse( stack )
    ip_json = stack_json["Stacks"][0]['Outputs'].select { |o| o['OutputKey'] == args.instanceName }.first
    raise "Could not find ip for instance '#{args.instanceName}'" unless ip_json
    puts ip_json['OutputValue']

    identity="-i ~/.ssh/tst/tst"

    sh "ssh ubuntu@#{ip_json['OutputValue']} #{identity}"
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

