#!/usr/bin/env ruby


require 'thor'
require_relative '../lib/aws-must'

class App < Thor

  include Utils::MyLogger     # mix logger
  PROGNAME = "main"           # logger progname

  # default values

  DEAFAULT_TEMPLATE="root"    # name of template in :template_path -directory

  # DEFAUL_FOLD_ON="<!--*SED-MAGIC* <div class=window> -->"     # default output for +++fold-on+++ tag
  # DEFAUL_FOLD_OFF="<!--*SED-MAGIC* </div>  -->"               # default output for +++fold-off+++ tag

  # default output for +++fold-on+++ tag
  DEFAUL_FOLD_ON="<div class='fold'>Check to show template: <input type='checkbox' class='toggle'/><div>"
  DEFAUL_FOLD_OFF="</div></div>"                # default output for +++fold-off+++ tag

  # ------------------------------------------------------------------

  class_option :log, :aliases => "-l", :type =>:string, :default => nil, 
  :enum => [ "DEBUG", "INFO", "WARN", "ERROR" ],
  :desc => "Set debug level "

  # ------------------------------------------------------------------
  # action 'doc'

  desc "doc", "Extract template documentation"

  option :template_path, :aliases => "-t", :type => :string, 
  :default => "mustache", 
  :desc => "Directory holding mustache templates"

  option :fold_on, :aliases => "-n", :type => :string, 
  :default => DEFAUL_FOLD_ON, 
  :desc => "Output for +++fold-on+++ tag"

  option :fold_off, :aliases => "-f", :type => :string, 
  :default => DEFAUL_FOLD_OFF, 
  :desc => "Output for +++fold-off+++ tag"

  long_desc <<-LONGDESC

  Extract documation from <template_name> in ':template_path' -directory.

  <template_name> defaults to '#{DEAFAULT_TEMPLATE}'


  Documentation is extracted from lines surrounded by #{AwsMust::Docu::DEFAULT_OPEN_TAG} and #{AwsMust::Docu::DEFAULT_CLOSE_TAG} tags,
  or by  #{AwsMust::Docu::DEFAULT_FOLD_ON_TAG} and  #{AwsMust::Docu::DEFAULT_FOLD_OFF_TAG} tags. 

  Following rules apply:

  - #{AwsMust::Docu::DEFAULT_OPEN_TAG},  #{AwsMust::Docu::DEFAULT_CLOSE_TAG} -tags: nothing is outputted for these lines

  - #{AwsMust::Docu::DEFAULT_FOLD_ON_TAG} -tag: output text for --fold_on option (defaults '#{DEFAUL_FOLD_ON}')

  - #{AwsMust::Docu::DEFAULT_FOLD_OFF_TAG} -tag: output text for --fold_off option (defaults '#{DEFAUL_FOLD_OFF}')


  Defult fold_on and fold_off parameters implement toggle when using following css-code

          /* Support fold-on/fold-off toggle */\n
          div.fold { width: 90%; padding: .42rem; border-radius: 5px;  margin: 1rem; }\n
          div.fold div { height: 0px; margin: .2rem; overflow: hidden; }\n
          div.toggle ~ div { height: 0px; margin: .2rem; overflow: hidden; }\n
          input.toggle:checked ~ div { height: auto;color: white; background: #c6a24b;font-family: monospace;white-space: pre; }\n


LONGDESC

  def doc( template_name=DEAFAULT_TEMPLATE )

    app = ::AwsMust::AwsMust.new( options )
    app.doc( template_name )

  end

  # ------------------------------------------------------------------
  # action 'json'

  desc "json <yaml_file> [with_adjust]", "Dump configuration in JSON format (with or without adjustment)"

  long_desc <<-LONGDESC

  Reads <yaml_file> and dumps it to stdout in JSON format
  'with_adjust' (yes/no)

  By default 'adjusts' data, i.e. adds property "_comma" with the
  value "," to each sub document, expect the last sub-document is
  adjusted with empty string "".

  The "_comma" -property helps in generating valid json arrays in
  mustache templates. For example, YAML construct

    tags:
       - Key: key1
         Value: value1

       - Key: key2
         Value: value2

  and Mustache template snippet

  { "Tags" : [ 
       {{#tags}}
           { "Key" : "{{Key}}",  "Value" : "{{Value}}"{{_comma}} }
       {{/tags}} 
  ]}

  results to valid JSON document

  { "Tags" : [ 
           { "Key" : "key1",  "Value" : "value1", 
           { "Key" : "key2",  "Value" : "value2"
  ]}

LONGDESC


  def json( yaml_file, with_adjust="true" )

    app = ::AwsMust::AwsMust.new( options )
    app.json( yaml_file, with_adjust =~ /^true$/ || with_adjust =~ /^yes$/  ? true : false  )

  end


  # ------------------------------------------------------------------
  # action 'gen'

  desc "gen <yaml_file> [<template_name>]", "Generate CloudFormation JSON template"

  option :template_path, :aliases => "-t", :type => :string, 
  :default => "mustache", 
  :desc => "Directory holding mustache templates"

  long_desc <<-LONGDESC

  Generate Amazon CloudFormation JSON file for <yaml_file> using
  <template_name> in ':template_path' -direcotory.

  <template_name> defaults to '#{DEAFAULT_TEMPLATE}'

LONGDESC


  def gen( yaml_file, template_name=DEAFAULT_TEMPLATE )

    app = ::AwsMust::AwsMust.new( options )
    app.generate( template_name, yaml_file, options )

  end

end

App.start
