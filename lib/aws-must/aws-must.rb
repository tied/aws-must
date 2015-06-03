require 'yaml'

module AwsMust

  class AwsMust

    include Utils::MyLogger          # mix logger
    PROGNAME = "aws-must"            # logger progname
    include Utils::Hasher            # mix logger

    # ------------------------------------------------------------------
    # attributes

    attr_accessor  :template         # mustache (or something else)
     
    def initialize( options={} )

      # init logger
      @logger = getLogger( PROGNAME, options )
      @logger.info( "#{__method__}" )

      # create object, which knows how to generate CloudFormation template json
      @template = Template.new( options ) 
    end

    def generate( template_name, yaml_file, options ) 

      @logger.debug( "#{__method__}, template_name '#{template_name}'" )
      @logger.debug( "#{__method__}, yaml_file= '#{yaml_file}'" )


      raise "YAML file #{yaml_file} does not exist" unless File.exist?( yaml_file )
      data = YAML.load_file( yaml_file )

      # some 'quirks' on data 
      data = adjust( data )
      @logger.debug( "#{__method__}, data= '#{data}'" )

      puts template.to_str( template_name, data )

    end

    private

    # deeply iterate 'data' -hash and add comma (,) to all expect the
    # last hash in arrays
    def adjust( data )
      return addComma( data )
    end


  end

end
