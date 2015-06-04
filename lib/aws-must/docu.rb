
module AwsMust

  class Docu 

    include ::Utils::MyLogger        # mix logger
    PROGNAME = "docu"                # progname for logger

    # ------------------------------------------------------------------
    # constants

    DEFAULT_OPEN_TAG      ="++start++"
    DEFAULT_CLOSE_TAG     ="++close++"
    DEFAULT_INCLUDE_TAG   =">"


    # ------------------------------------------------------------------
    # Attributes

    # static


    # instance 

    # ------------------------------------------------------------------
    # Constructor
    # - template: which knows how to return template files
    
    def initialize( template, options={} )

      @logger = getLogger( PROGNAME, options )
      @logger.info( "#{__method__}, options=#{options}" )

      @template = template

      @directives = {
        :open => DEFAULT_OPEN_TAG,
        :close => DEFAULT_CLOSE_TAG,
        :include => DEFAULT_INCLUDE_TAG,
      }

    end

    # ------------------------------------------------------------------
    # docu - output documentation to stdout

    def document( template_name )

      @logger.debug( "#{__method__}, template_name '#{template_name}'" )
      
      # 
      template_string = @template.get_template( template_name )
      @logger.debug( "#{__method__}, template_string= '#{template_string}'" )

      # 
      state_opened=false

      # iterate lines
      template_string && template_string.split( "\n" ).each do | line |

        if !state_opened then

          # waiting for +++open+++

          open_found, line = directive_open( line )
          if open_found then

            state_opened = true
            
            # something follows the start -tag
            redo if line && ! line.empty?

          end

        else 

          # seen +++open+++, waiting for +++close+++

          close_found, line_pre, line = directive_close( line )
          # puts "close_found=#{close_found}, #{close_found.class}, line=#{line}"
          if  close_found then
            output( line_pre ) if line_pre && !line_pre.empty?
            state_opened = false
            redo if line && ! line.empty?
          elsif template_name = directive_include( line ) then
            document( template_name )
          else
            output( line )
          end

        end # state_opened
      end # each line

    end # end - document

    # ------------------------------------------------------------------
    # output - document output

    def output( line )

      puts( line ) 
    end


    # ------------------------------------------------------------------
    # Check if line satisfies tag

    def directive_open( line )
      # return line && line.include?( get_tag(:open) )
      if line && line.include?( get_tag(:open) ) then
        # find index pointing _after_ :open tag
        index = line.index( get_tag(:open) ) + get_tag(:open).length
        return  true, line[ index..-1]

      else
        return false, nil
      end
    end
    
    # return bool, line_pre, line
    def directive_close( line )
      #return line && line.include?( get_tag( :close ) )
      if line && line.include?( get_tag( :close ) ) then
        index = line.index( get_tag(:close) )
        return true, index == 0 ? nil : line[0..index-1],  line[ index+ get_tag(:close).length..-1]
      else
        return false, nil, line
      end
    end
    

    # return include 'template' to include if it is include directive
    def directive_include( line )

      # not valid input
      return nil unless line
      
      # extract template_name using regexp
      parse_regexp=/^#{get_tag(:include)}\s+(?<template>[\w]*)\s*/
      parsed = line.match( parse_regexp )

      # not found
      return nil unless parsed
      return parsed['template']

    end

    # ------------------------------------------------------------------
    # get tag value
    def get_tag( tag )
      raise "Unknown tag" unless @directives[tag]
      return @directives[tag]
    end
    

  end # class

end # module
