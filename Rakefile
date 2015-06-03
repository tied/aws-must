# -*- mode: ruby -*-

# ------------------------------------------------------------------
# default


task :default => [:usage]

# ------------------------------------------------------------------
# demo

namespace "demo" do |ns|

  # --------------------
  # Demo configs

  cmd="bin/aws-must.rb"                # generator being demonstrated
  demo_dir="demo"                      # directory holding demo configs
  stack="demo"                         # name of the on Amazon

  [ 

   { :id => "1", :desc=>"Initial copy"  },
   { :id => "2", :desc=>"Added 'description' -property to YAML file"  },
   { :id => "3", :desc=>"Use resources.mustache -partial to create EC2 intance"  },
   { :id => "4", :desc=>"EC2 instance configuration using YAML-data"  },
   { :id => "5", :desc=>"Add 'Outputs' -section with reference to EC2 instance"  },
   { :id => "6", :desc=>"Add 'Inputs' and 'Mappings' -sections to parametirize "  }

  ].each do  |c|

    desc "Output CF template using configs in '#{demo_dir}/#{c[:id]}' to demonstrate '#{c[:desc]}'"
    task "template-#{c[:id]}" do
      sh "#{cmd} gen -t #{demo_dir}/#{c[:id]} #{demo_dir}/#{c[:id]}/conf.yaml"
    end

    desc "Create stack #{stack} using using configs  in '#{demo_dir}/#{c[:id]}' to demonstrate '#{c[:desc]}'"
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
