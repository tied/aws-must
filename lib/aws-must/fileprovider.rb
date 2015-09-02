module AwsMust

  # allow Docu class to access files 
  class FileProvider 
    def initialize( optionss=nil )
    end
    # return lines in a file as a long string
    def get_template( file_name )
      return File.readlines( file_name ).join
    end
  end

end
