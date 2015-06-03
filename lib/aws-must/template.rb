
require 'mustache'                   # extendending implementation of


module AwsMust

  class Template < Mustache

    include ::Utils::MyLogger        # mix logger
    PROGNAME = "template"            # progname for logger

    # ------------------------------------------------------------------
    # Attributes

    # static
    @@template_path = nil            # directory where templates stored
    @@template_extension = "mustache"# type part in filename

    # instance 
    attr_writer :partials            # f: partial-name --> template string
    attr_writer :templates           # f: template-name --> template string

    # ------------------------------------------------------------------
    # Constructor
    
    def initialize( options={} )
      @logger = getLogger( PROGNAME, options )
      @logger.info( "#{__FILE__}.#{__method__} created" )
      @logger.debug( "#{__FILE__}.#{__method__}, options='#{options}" )
      # for mustache templates
      @@template_path = options[:template_path] if options[:template_path]
    end

    # ------------------------------------------------------------------
    # Services
    
    def to_str( template_name, data )
      @logger.debug( "#{__method__}: template_name=#{template_name}, data=#{data}" )
      if template_name 
        template = get_template( template_name )
        render( template, data )
      else
        render( data )
      end
    end

    # ------------------------------------------------------------------
    # Integrate with mustache

    # method used by mustache framework - delegate to 'get_partial'
    def partial(name)
      @logger.debug( "#{__FILE__}.#{__method__} name=#{name}" )
      # File.read("#{template_path}/#{name}.#{template_extension}")
      get_partial( name )
    end

    # cache @partials - for easier extension
    def get_partial( name ) 
      @logger.debug( "#{__FILE__}.#{__method__} name=#{name}" )
      return @partials[name] if @partials && @partials[name]

      partial_file = "#{@@template_path}/#{name}.#{template_extension}"
      @logger.info( "#{__FILE__}.#{__method__} read partial_file=#{partial_file}" )
      File.read( partial_file )
    end

    # hide @templates - for easier extension
    def get_template( name ) 

      @logger.debug( "#{__FILE__}.#{__method__} name=#{name}" )
      return @templates[name] if @templates && @templates[name]

      template_path = "#{@@template_path}/#{name}.#{@@template_extension}"
      @logger.info( "#{__FILE__}.#{__method__} read template_path=#{template_path}" )

      File.read( template_path )
    end

  end # class

end # module
