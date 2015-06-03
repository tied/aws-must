# aws-must - Minimum Viable Solution to Manage CloudFormation Templates

`aws-must` is a tool, which allows separating infrastructure
configuration and Amazon related syntax using
[YAML](http://learnxinyminutes.com/docs/yaml) and
[Mustache templates](https://mustache.github.io/). Template
documentation can generated automagically from tagged section in
template comments.

be documented automatically
by Documentation of the templates is supported based on the
[Code As Documentation](http://martinfowler.com/bliki/CodeAsDocumentation.html)
idea.

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

4. add comments in YAML and Mustache templates. A special markup in
   Mustache template comment sections, allows automatic generation of
   template documentation.

5. write reusable template elements using Mustache partials.

6. concentrate on configurations expressed in YAML (with minimal markdown).


## Installation

## Usage

### CLI  Usage

### Demo Usage

#### Demo Usage Locally

A list of demo cases, stored under `demo` sub directory, can be shown
with the command

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

#### Demo Usage on Amazon platform

Demo stacks can be provisioned on Amazon platform.

**WARNING** Provisioning CloudFormation templates on Amazon will be
**charged according to Amazon pricing policies**.

Prerequisites:

* [Install Amazon AWS Command Line Interface](http://docs.aws.amazon.com/cli/latest/userguide/installing.html)
* [Configure AWS Command Line Interface](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)

To list demo stacks run the command

	rake -T demo:stack

**NOTICE**: Please, notice the region constraint in the output. Some
of the templates use fixed AMI configuration, which means that they
work only if aws -tool defines correct region (typically in set in
`~/.aws/config` file).

To create a `demo` stack for demo case `i`, for example demo case 6
run

	rake  demo:stack-6
	
to show status of `demo` stack

	rake  demo:stack-status

to show events of `demo` stack

	rake  demo:stack-events

to delete `demo` stack

	rake  demo:stack-delete

	 
	 


