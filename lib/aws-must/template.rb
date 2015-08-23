
require 'mustache'                   # extendending implementation of


module AwsMust

  class Template < Mustache

    include ::Utils::MyLogger        # mix logger
    PROGNAME = "template"            # progname for logger

    # ------------------------------------------------------------------
    # Attributes

    # instance 
    attr_writer :partials            # f: partial-name --> template string
    attr_writer :templates           # f: template-name --> template string

    # ------------------------------------------------------------------
    # Constructor
    
    def initialize( options={} )
      @logger = getLogger( PROGNAME, options )
      @logger.info( "#{__FILE__}.#{__method__} created" )
      @logger.debug( "#{__FILE__}.#{__method__}, options='#{options}" )

      @template_paths = []            # array of directories for templates
      @template_extension = "mustache"# type part in filename

      # for mustache templates
      @template_paths.concat( options[:template_path] && options[:template_path].respond_to?(:each) ? options[:template_path] : [ options[:template_path]  ] )

    end

    # ------------------------------------------------------------------
    # Services
    
    def to_str( template_name=nil, data=nil )
      @logger.debug( "#{__method__}: template_name=#{template_name}, data=#{data}" )
      if template_name 
        template = get_template( template_name )
        render( template, data )
      elsif data
        render( data )
      else
        puts @templates
      end
    end

    # ------------------------------------------------------------------
    # Integrate with mustache

    # method used by mustache framework - delegate to 'get_partial'
    def partial(name)
      @logger.debug( "#{__FILE__}.#{__method__} name=#{name}" )
      get_partial( name )
    end

    # cache @partials - for easier extension
    def get_partial( name ) 
      @logger.debug( "#{__FILE__}.#{__method__} name=#{name}" )
      return @partials[name] if @partials && @partials[name]

      partial_file = get_template_filepath( name )
      @logger.info( "#{__FILE__}.#{__method__} read partial_file=#{partial_file}" )
      File.read( partial_file )
    end

    # hide @templates - for easier extension
    def get_template( name ) 

      template_file = get_template_filepath( name )
      @logger.info( "#{__FILE__}.#{__method__} read template_file=#{template_file}" )
      File.read( template_file )

    end # def get_template( name ) 


    # return path to an existing template file name 
    private

    def get_template_filepath( name ) 

      @template_paths.each do |directory| 

        template_path = get_template_filepath_in_directory( directory, name ) 
        
        return template_path if File.exists?( template_path ) 

      end # each 


      # could not find 
      
      raise <<-eos

          No such file  '#{template_path}'.
 
          Use opition -t to point to a directory, which contains file '#{name}.#{@template_extension}'
        
        eos


    end

    # return path to 'template_file' in an existing 'directory'
    def get_template_filepath_in_directory( directory, template_file ) 
      @logger.debug( "#{__FILE__}.#{__method__} template_file=#{template_file}" )

      if ! File.exists?( directory ) then
        raise <<-eos

          No such directory '#{directory}'.
 
          Use opition -t to point to an existing directory.
        
        eos

      end

      template_path = "#{directory}/#{template_file}.#{@template_extension}"
      @logger.info( "#{__FILE__}.#{__method__} read template_path=#{template_path}" )
      
      return template_path

    end


  end # class

end # module
