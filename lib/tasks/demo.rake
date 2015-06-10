# -*- mode: ruby -*-

# demo.rake

# Thank You!
# http://andyatkinson.com/blog/2014/06/23/sharing-rake-tasks-in-gems

require 'json'

namespace "demo" do |ns|

  # --------------------
  # Demo configs

  cmd = File.join File.dirname(__FILE__), "../../bin/aws-must.rb"   # generator being demonstrated
  demo_dir=File.join File.dirname(__FILE__), "../../demo"           # directory holding demo configs
  stack="demo"                                                      # stack name of the on Amazon
  default_private_key_file="~/.ssh/demo-key/demo-key"                       # private keyfile corresponding 

  all_regions= ["ap-northeast-1", "ap-southeast-1", "ap-southeast-2", "cn-north-1", "eu-central-1", "eu-west-1", "sa-east-1", "us-east-1", "us-gov-west-1", "us-west-1", "us-west-2"] 

  [ 

   { :id => "1", :desc=>"Initial copy", :region=>['eu-central-1'], :ssh => false },
   { :id => "2", :desc=>"Added 'description' -property to YAML file", :region=>['eu-central-1'], :ssh => false  },
   { :id => "3", :desc=>"Use resources.mustache -partial to create EC2 intance", :region=>['eu-central-1'], :ssh => false    },
   { :id => "4", :desc=>"EC2 instance configuration using YAML-data", :region=>['eu-central-1'], :ssh => false    },
   { :id => "5", :desc=>"Add 'Outputs' -section with reference to EC2 instance", :region=>['eu-central-1'], :ssh => false    },
   { :id => "6", :desc=>"Add 'Inputs' and 'Mappings' -sections to parametirize", :region=> all_regions, :ssh => false  },
   { :id => "7", :desc=>"Added support for input parameters, EC2 tags, Instance security group", :region=>all_regions, :ssh => false  },


  ].each do  |c|

    desc "Output CF template using configs in '#{demo_dir}/#{c[:id]}' to demonstrate '#{c[:desc]}'"
    task "template-#{c[:id]}" do
      sh "#{cmd} gen -t #{demo_dir}/#{c[:id]} #{demo_dir}/#{c[:id]}/conf.yaml"
    end

    desc "Output configs in '#{demo_dir}/#{c[:id]}' in JSON to demonstrate '#{c[:desc]}'"
    task "json-#{c[:id]}" do
      sh "#{cmd} json #{demo_dir}/#{c[:id]}/conf.yaml"
    end

    desc "Check the difference between version '#{c[:id]}' and :prev (default '#{c[:id].to_i() -1}') "
    task "diff-#{c[:id]}", :prev do |t,args|

      args.with_defaults( prev:  c[:id].to_i() -1 )

      # use bash temporary names pipes to diff two stdouts
      # Use `jq` to create canonical pretty print json
      sh "bash -c \"diff <(#{cmd} gen -t #{demo_dir}/#{c[:id]} #{demo_dir}/#{c[:id]}/conf.yaml | jq . ) <(#{cmd} gen -t #{demo_dir}/#{args.prev} #{demo_dir}/#{args.prev}/conf.yaml | jq . ) || true \""
    end

    desc "Create stack #{stack} for demo case #{c[:id]}, supported regions=#{c[:region]}"
    task "stack-create-#{c[:id]}" do
      sh "aws cloudformation create-stack --stack-name #{stack}  --template-body \"$(#{cmd} gen -t #{demo_dir}/#{c[:id]} #{demo_dir}/#{c[:id]}/conf.yaml)\""
    end

    desc "Open html documentation in 'browser' (default 'firefox')"
    task "html-#{c[:id]}", :browser  do |t,args|

      args.with_defaults( browser: "firefox" )

      sh "#{cmd} doc -t #{demo_dir}/#{c[:id]} | markdown | #{args.browser} \"data:text/html;base64,$(base64 -w 0 <&0)\""
    end


    desc "Copy demo case #{c[:id]} to :templateDir and :configDir"
    task "bootstrap-#{c[:id]}", :templateDir,:configDir do  |t, args|

      usage =  "Task '#{t}' usage: #{t}[:templateDir,:configDir]" 
      raise usage if args.templateDir.nil?
      raise usage if args.configDir.nil?

      raise "Directory #{args.templateDir} does not exist" unless File.exists?( args.templateDir )
      raise "Directory #{args.configDir} does not exist" unless File.exists?( args.configDir )


      puts (<<-EOS) if args.templateDir == args.configDir
           
              Warning :templateDir == :configDir == #{args.templateDir}
              Suggestion to keep templates and configurations in a separate directory

      EOS

      demoTemplates = File.join demo_dir, c[:id], "*.mustache"
      configFiles = File.join demo_dir, c[:id], "*.yaml"

      Dir[demoTemplates].each { |f| 	
        FileUtils.cp(f, args.templateDir, :verbose=>true )
      }

      Dir[configFiles].each { |f| 	
        FileUtils.cp(f, args.configDir, :verbose=>true )
      }

    end


  end

  desc "Show status of CloudFormation stack"
  task "stack-status" do
    sh "aws cloudformation describe-stacks"
  end

  desc "Ssh connection to ':ipName' using ':private_key' default (#{default_private_key_file})"
  task 'stack-ssh', :ipName, :private_key  do |t, args|

    raise "Task '#{t}' usage: #{t}[ipName,private_key] - exiting"  if args.ipName.nil?

    stack_string = %x{ aws cloudformation describe-stacks --stack-name #{stack} }
    raise "Error #{$?.exitstatus}" if $?.exitstatus != 0

    args.with_defaults( private_key: default_private_key_file )

    stack_json = JSON.parse( stack_string )
    ip_json = stack_json["Stacks"][0]['Outputs'].select { |o| o['OutputKey'] == args.ipName }.first
    raise "Could not find ip for 'ipName' '#{args.ipName}' in output section of #{stack} stack" unless ip_json

    puts ip_json['OutputValue']
    identity="-i #{args.private_key}"

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

