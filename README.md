# aws-must - Minimum Viable Solution to Manage CloudFormation Templates

`aws-must` is a tool, which allows separating infrastructure
configuration and Amazon related syntax using
[YAML](http://learnxinyminutes.com/docs/yaml) and
[Mustache templates](https://mustache.github.io/). 


## The problem

[Amazon CloudFormation](http://aws.amazon.com/cloudformation/) gives
developers and systems administrators an easy way to create and manage
a collection of related AWS resources.  It uses JSON -formatted
[templates](http://aws.amazon.com/cloudformation/aws-cloudformation-templates)
for defining services to be managed together as a "stack".

However, the CF -templates soon become quite convoluted as the
complexity of the infrastructure stack increases. In addition, the
JSON format adds more to the management difficulties:

1. each stack is represented as a monolithic JSON document.

2. templates mix infrastructure specific configuration with the syntax
   stipulated by
   [Amazon CloudFormation Template Reference](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-reference.html)

3. the JSON format doesn't support expressing references, and
   CloudFormation needs to use a
   [special syntax](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-ref.html)
   to define relations across template elements.

4. the JSON format doesn't support comments, which could be used to
   add documentation into the templates.

5. JSON documents repeat similar sections as resource instances are
   defined individually as sub-documents.

6.  JSON adds it own markup overhead to the configuration.

## The solution

With `aws-tool` users may

1.  divide configuration task first in half (YAML/mustache templates),
    and then further down using Mustache partials

2. separate infrastructure specific configuration from syntax
   stipulated by
   [Amazon CloudFormation Template Reference](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-reference.html)
   using YAML and Mustache templates.

3. use YAML anchors to express dependencies between infrastructure
   elements.

4. add comments in YAML and Mustache templates. The tool supports
   simple tag syntax (**&plus;&plus;start&plus;&plus;**
   **&plus;&plus;close&plus;&plus;** -tags) to add documentation to
   Mustache templates, which can be extracted to a separate document.

5. use Mustache partials to get rid of repeating similar sections in
   JSON configuration.

6. concentrate on configurations expressed in YAML (with minimal markdown).


## Installation

Add following line to `Gemfile`

	gem 'aws-must'


and run

	bundle install
	

## Usage

### CLI  Usage

To get help 	

	aws-must.rb help

To create CloudFormation JSON template for `yaml_file` using default
template `./mustache/root.mustache` issue the command

	aws-must.rb gen yaml_file
	

To extract documentation from template `./mustache/root.mustache`
issue the command

	aws-must.rb doc 

To dump YAML `yaml_file` in JSON format

	aws-must.rb json yaml_file


### Demo Usage

Add following lines to `Rakefile`

```
spec = Gem::Specification.find_by_name 'aws-must'
load "#{spec.gem_dir}/lib/tasks/demo.rake"
```

and verify that `demo` namespace is added to rake tasks

	rake -T demo

#### Demo Usage Locally

A list of demo cases is shown with the command

	rake -T demo:template

	
To show the CloudFormation JSON template for a demo case `i`, where
`i` ranges from `1,2,3, ...`, run rake task `dev:template-i`. For
example, for demo case `1` run

	rake -T demo:template-1

To show the difference of running case `i` vs running the previous
demo case, run rake task `dev:diff-i`. For example, for demo case `2`
run

	rake -T demo:diff-2
	
**NOTICE:**: The [jq](http://stedolan.github.io/jq/) must be installed
for diff target to work.


Create JSON 

	bin/aws-must.rb  gen configDir/conf.yaml  -t templateDir
	
Extract documentation from templates in `tewmplateDir`

	bin/aws-must.rb  doc -t templateDir

#### Use Demo to Bootstrap Own Configuration

To create your own bootstrap configuration for demo case i, for case `3` run

    rake demo:bootstrap-3[templateDir,configDir]
	
where 	

* `templateDir` points to a directory, where mustache templates will be copied
* `configDir` points to a directory, where demo YAML configuration
  will be copied

After this command `templateDir` contains `root.mustache`, which is
the starting point of mustache template rendering, and `configDir`
contains a YAML file `conf.yaml` for demo configuration data.





#### Demo Usage on Amazon platform

Demo stacks can be provisioned on Amazon platform.

**WARNING** Provisioning CloudFormation templates on Amazon will be
**charged according to Amazon pricing policies**.

Prerequisites:

* [Install Amazon AWS Command Line Interface](http://docs.aws.amazon.com/cli/latest/userguide/installing.html)
* [Configure AWS Command Line Interface](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)

To list available demo targets

	rake -T demo:stack-create

**NOTICE**: Please, notice the region constraint in the output. Some
of the templates use fixed AMI configuration, which means that they
work only if aws -tool defines correct region (typically in set in
`~/.aws/config` file).

**NOTICE**: Demo-case `7,8, ...` make use of public ssh-key
`demo-key`. See
[Amazon EC2 Key Pairs](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)
page explains for possibilities, how to upload your own key.

**NOTICE**: Demo EC2 instances `7,8, ...` allow any IP address to make
a SSH connection to the EC2 instances, i.e. they use ingnress CIRD
`0.0.0.0/0`.
	

To create a `demo` stack for demo case `i`, for example demo case 7
run

	rake  demo:stack-create-7
	
To show events generated while `demo` stack is created run

	rake  demo:stack-events
	
To show status of `demo` stack run

	rake  demo:stack-status
	

To make a ssh connection (for demo cases `7,8,...`)

    rake demo:stack-ssh[IP1,<private-ssh-key-file>]
	
where

* `IP1` : is the name of stack output variable holding IP address 
* `<private-ssh-key-file>` is the file path of ssh private key for
  [Amazon SSH-key pair](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)
  `demo-key`.


To delete `demo` stack

	rake  demo:stack-delete


	
	



	 


