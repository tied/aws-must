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
  # make two thor tasks share options?
  # http://stackoverflow.com/questions/14346285/how-to-make-two-thor-tasks-share-options

  class << self
    def add_shared_option(name, options = {})
      @shared_options = {} if @shared_options.nil?
      @shared_options[name] =  options
    end

    def shared_options(*option_names)
      option_names.each do |option_name|
        opt =  @shared_options[option_name]
        raise "Tried to access shared option '#{option_name}' but it was not previously defined" if opt.nil?
        option option_name, opt
      end
    end
  end

  def initialize(*args)
    super
    @logger = getLogger( PROGNAME, options )
  end

  # ------------------------------------------------------------------

  class_option :log, :aliases => "-l", :type =>:string, :default => nil, 
  :enum => [ "DEBUG", "INFO", "WARN", "ERROR" ],
  :desc => "Set debug level "


  # ------------------------------------------------------------------
  add_shared_option :template_gem, :aliases => "-g", :type => :string,
  :desc => "Mustache template Gem name (optionally with version constraint e.g. 'aws-must-templates,~>0.0.1')"

  add_shared_option :template_path, :aliases => "-t", :type =>
  :string, :default => "mustache", 
  :desc => "Directory holding mustache templates"


  # ------------------------------------------------------------------
  # action 'doc'

  desc "doc", "Extract template documentation"

  shared_options :template_path
  shared_options :template_gem

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


  Defult fold_on and fold_off parameters implement CCS-toggle when using following css-code

          /* CSS-support fold-on/fold-off toggle */\n
          div.fold { width: 90%; padding: .42rem; border-radius: 5px;  margin: 1rem; }\n
          div.fold div { height: 0px; margin: .2rem; overflow: hidden; }\n
          div.toggle ~ div { height: 0px; margin: .2rem; overflow: hidden; }\n
          input.toggle:checked ~ div { height: auto;color: white; background: #c6a24b;font-family: monospace;white-space: pre; }\n


LONGDESC

  def doc( template_name=DEAFAULT_TEMPLATE )

    @logger.info( "#{__FILE__}.#{__method__} starting" )

    
    my_options = option_adjust_common( options )

    app = ::AwsMust::AwsMust.new( my_options )
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

  shared_options :template_path
  shared_options :template_gem

  long_desc <<-LONGDESC

  Generate Amazon CloudFormation JSON file for <yaml_file> using
  <template_name> in ':template_path' -directory.

  <template_name> defaults to '#{DEAFAULT_TEMPLATE}'

LONGDESC


  def gen( yaml_file, template_name=DEAFAULT_TEMPLATE )

    my_options = option_adjust_common( options )

    app = ::AwsMust::AwsMust.new( my_options )
    app.generate( template_name, yaml_file, my_options )

  end

  # ------------------------------------------------------------------
  # common routines
  no_commands do

    def option_adjust_common( options ) 

      raise "No optios give" unless options
      ret = options
      ret = option_template_gem_to_template_path( options )  if options[:template_gem]
      
      return ret
    end


    def option_template_gem_to_template_path( options ) 

      # The version requirements are optional.
      # You can also specify multiple version requirements, just append more at the end
      gem_spec = options[:template_gem].split(',')
      gem_name, *gem_ver_reqs = gem_spec[0], gem_spec[1]
      gdep = Gem::Dependency.new(gem_name, *gem_ver_reqs)
      # find latest that satisifies
      found_gspec = gdep.matching_specs.sort_by(&:version).last
      # instead of using Gem::Dependency, you can also do:
      # Gem::Specification.find_all_by_name(gem_name, *gem_ver_reqs)

      if found_gspec
        # unfreeze options
        @logger.debug( "#{__FILE__}.#{__method__}, Requirement '#{gdep}' already satisfied by #{found_gspec.name}-#{found_gspec.version}" )
        @logger.debug( "#{__FILE__}.#{__method__}, old-options=#{options}" )
        options = options.dup
        options[:template_path] = "#{found_gspec.gem_dir}/mustache"
        @logger.debug( "#{__FILE__}.#{__method__}, new-options=#{options}" )
      else
        #puts "Requirement '#{gdep}' not satisfied; installing..."
        # ver_args = gdep.requirements_list.map{|s| ['-v', s] }.flatten
        # # multi-arg is safer, to avoid injection attacks
        # system('gem', 'install', gem_name, *ver_args)
        raise "Could not find gem '#{gdep}' - try 'gem install #{gdep}'"
      end
      
      return options

    end
    
  end # no commands

end

App.start
