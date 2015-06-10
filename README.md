# aws-must - Minimum Viable Solution to Manage CloudFormation Templates - $Release:0.0.3$

`aws-must` is a tool, which allows separating infrastructure
configuration and Amazon related syntax using
[YAML](http://learnxinyminutes.com/docs/yaml) and
[Mustache templates](https://mustache.github.io/). 


## The Problem

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

`aws-tool` helps mitigating the problems presented in the chapter
above.  With the tool users may

1.  split stack configuration first in half, using YAML/mustache
    templates, and then further down using Mustache partials

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

To extract documentation between **&plus;&plus;start&plus;&plus;**
**&plus;&plus;close&plus;&plus;** -tags from template
`./mustache/root.mustache` issue the command

	aws-must.rb doc 

To dump YAML `yaml_file` in JSON format

	aws-must.rb json yaml_file


### Demo Usage

Add the following lines to `Rakefile`


	spec = Gem::Specification.find_by_name 'aws-must'
	load "#{spec.gem_dir}/lib/tasks/demo.rake"


and verify that `demo` namespace is added to rake tasks

	rake -T demo

#### Demo Usage Locally

A list of demo cases is shown with the command

	rake -T demo:template
	
To show the CloudFormation JSON rendered for a demo case `i`, where
`i` ranges from `1,2,3, ...`, run rake task `dev:template-i`. For
example, for demo case `1` run

	rake demo:template-1

To show the difference of running case `i` vs. running the previous
demo case, run rake task `demo:diff-i`. For example, for demo case `2`
run

	rake demo:diff-2
	
**NOTICE:**: The [jq](http://stedolan.github.io/jq/) must be installed
for diff target to work.

To show html documentation extracted from demo case `i` templates, run
rake task `demo:html-i`. For example, for demo case `3` run

	rake demo:html-3

**NOTICE:**: Uses `markdown` command to convert
[markdown](http://daringfireball.net/projects/markdown) documentation
into html.

**NOTICE:**: Default browser `firefox` can be changed using command
line argument `browser`, e.g. `rake demo:html-3[chromium-browser]`.

#### Use Demo to Bootstrap Own Configuration

To create a copy templates and YAML configuration for demo case `i`,
run rake task `demo:bootstrap-i` and pass command line arguments
defining template directory and configuration directory. For example,
to copy demo case `3` templates to directory `tmp/tmpl` and
configurations to `tmp/conf`, run

    rake demo:bootstrap-3[tmp/tmpl,tmp/conf]
	

After this command `tmp/tmpl` contains `root.mustache`, which is the
starting point of mustache template rendering, and `tmp/conf` contains
a YAML file `conf.yaml` for demo configuration data.


#### Demo Usage on Amazon platform

Demo stacks can be provisioned on Amazon platform.

**WARNING** Provisioning CloudFormation templates on Amazon will be
**charged according to Amazon pricing policies**.

Prerequisites:

* [Install Amazon AWS Command Line Interface](http://docs.aws.amazon.com/cli/latest/userguide/installing.html)
* [Configure AWS Command Line Interface](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)

To list demo targets, which provision Amazon, run

	rake -T demo:stack-create

**NOTICE**: Please, notice the region constraint in the output. Some
of the templates use fixed AMI configuration, which means that they
work only if aws -tool defines correct region (typically in set in
`~/.aws/config` file).


To create a `demo` stack for demo case `i`, for example demo case 7
run

	rake  demo:stack-create-7
	
To show events generated when `demo` stack is created run

	rake  demo:stack-events
	
To show status of `demo` stack run

	rake  demo:stack-status

EC2 instances created in demo cases `7,8,...` accept ssh
connections. 

Demo target `demo:stack-ssh` locates an ip address from a stack output
variable given as a parameter, and makes ssh connection to this ip
using the ssh identity given as a parameter.

For example, to use ip address in demo stack output variable `IP1`,
and the ssh private key in `~/.ssh/demo-key/demo-key`, run

    rake demo:stack-ssh[IP1,~/.ssh/demo-key/demo-key]

**NOTICE**: Use `rake  demo:stack-status` to show stack output variables.

**NOTICE**: The identity used must correspond to an existing
[Amazon EC2 Key Pair](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)
with the name `demo-key`.


To delete `demo` stack

	rake  demo:stack-delete


	
	



	 


