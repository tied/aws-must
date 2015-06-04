#!/usr/bin/env ruby


require 'thor'
require_relative '../lib/aws-must'

class App < Thor

  include Utils::MyLogger     # mix logger
  PROGNAME = "main"           # logger progname
  DEAFAULT_TEMPLATE="root"    # name of template in :template_path -directory


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

  long_desc <<-LONGDESC

  Extract documation from <template_name> in ':template_path' -direcotory.

  <template_name> defaults to '#{DEAFAULT_TEMPLATE}'

LONGDESC

  def doc( template_name=DEAFAULT_TEMPLATE )

    app = ::AwsMust::AwsMust.new( options )
    app.doc( template_name )

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