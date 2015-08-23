require_relative "../spec_helper"


# SUT
require 'aws-must'


describe "AwsMust::Template" do

  # ------------------------------------------------------------------
  # helpers

  let( :template_path ) { "/usr/lib/xx" }
  let( :template_path2 ) { "/usr/lib/yy" }
  let( :template_name ) { "template" }
  let( :template_filepath) {  "#{template_path}/#{template_name}.mustache" }
  let( :template_filepath2) {  "#{template_path2}/#{template_name}.mustache" }


  # ------------------------------------------------------------------
  # setup

  before :each do

    @options      = {
    }
    @sut         = ::AwsMust::Template.new( @options )

  end


  # ------------------------------------------------------------------
  # interface
  describe "interface" do

    it "#defines method 'get_template'" do
      expect( @sut ).to respond_to( :get_template )
    end 

    it "#defines method 'get_template'" do
      expect( @sut ).to respond_to( :get_partial )
    end 


  end # describe "interface" do

  # ------------------------------------------------------------------
  # template_path is a string

  describe "option :template_path as string " do
    
    context "when directory exixts" do

      before :each do

        @options      = {
          :template_path => template_path
        }

        @sut         = ::AwsMust::Template.new( @options )

        # directory exists
        expect( File ).to receive( :exists? ).with( template_path ).and_return( true )


      end

      describe "get_partial" do

        it "#reads 'template_name' from 'template_filepath'" do

          expect( File ).to receive( :exists? ).with( template_filepath ).and_return( true )

          expect( File ).to receive( :read ).with( template_filepath ).and_return( "file" )
          @sut.get_partial( template_name )

        end 

        it "#exection when 'template_name' does not exist in  'template_path'" do


          expect( File ).to receive( :exists? ).with( template_filepath ).and_return( false )

          expect { @sut.get_partial( template_name ) }.to raise_error( /No such file/ )
        end 

      end # describe "get_partial" do

      describe "get_template" do

        it "#reads 'template_name' from 'template_filepath'" do

          expect( File ).to receive( :exists? ).with( template_filepath ).and_return( true )
          expect( File ).to receive( :read ).with( template_filepath ).and_return( "file" )

          @sut.get_template( template_name )
        end 

        it "#exection when 'template_name' does not exist in  'template_path'" do

          expect( File ).to receive( :exists? ).with( template_filepath ).and_return( false )

          expect { @sut.get_template( template_name ) }.to raise_error( /No such file/ )
        end 

      end # describe "get_template" do

    end # context "when directory exixts" do

  end # describe "option :template_path as string " do

  # ------------------------------------------------------------------
  # template_path is a array of string

  describe "option :template_path as string " do
    
    context "second directory exist" do


      before :each do

        @options      = {
          :template_path => [ template_path, template_path2 ]
        }
        @sut         = ::AwsMust::Template.new( @options )


      end

      it "#reads 'template_name' from first path" do

        # check directories
        expect( File ).to receive( :exists? ).with( template_path ).and_return( true )
        expect( File ).not_to receive( :exists? ).with( template_path2 )

        # check files
        expect( File ).to receive( :exists? ).with( template_filepath ).and_return( true )
        expect( File ).not_to receive( :exists? ).with( template_filepath )

        # correct file read
        expect( File ).to receive( :read ).with( template_filepath ).and_return( "file" )
        
        # exercise
        @sut.get_partial( template_name )

      end 

      it "#reads 'template_name' from secord path" do

        # check directories - they exist
        expect( File ).to receive( :exists? ).with( template_path ).and_return( true )
        expect( File ).to receive( :exists? ).with( template_path2 ).and_return( true )

        # check files - 2nd is found
        expect( File ).to receive( :exists? ).with( template_filepath ).and_return( false )
        expect( File ).to receive( :exists? ).with( template_filepath2 ).and_return( true )

        # correct file read
        expect( File ).to receive( :read ).with( template_filepath2 ).and_return( "file" )
        
        # exercise
        @sut.get_partial( template_name )

      end 

      it "#exception when neither directory contains file 'template_name'" do

        # check directories - they exist
        expect( File ).to receive( :exists? ).with( template_path ).and_return( true )
        expect( File ).to receive( :exists? ).with( template_path2 ).and_return( true )

        # check files - 2nd is found
        expect( File ).to receive( :exists? ).with( template_filepath ).and_return( false )
        expect( File ).to receive( :exists? ).with( template_filepath2 ).and_return( false )

        # correct file read
        expect( File ).not_to receive( :read ).with( template_filepath )
        expect( File ).not_to receive( :read ).with( template_filepath2 )
        
        # exercise
        expect { @sut.get_partial( template_name ) }.to raise_error( /No such file/ )

      end 

    end # context "directory exist" do

  end # describe "option :template_path as string " do


end

