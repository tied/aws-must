=begin

+++start+++

This text is outputted

+++close+++

=end


require_relative "./spec_helper"


describe App do

  before :each do
    output = with_captured_stdout() { @sut = App.new }
  end

  it "#works" do
    expect( 1 ).to eql( 1 )
  end

  # ------------------------------------------------------------------
  # Command line interface

  describe "Command Line Interface" do
    
    it "#doc" do
      expect( @sut ).to respond_to( :doc )
    end

    it "#ddoc" do
      expect( @sut ).to respond_to( :ddoc )
    end

    it "#gen" do
      expect( @sut ).to respond_to( :gen )
    end

    it "#json" do
      expect( @sut ).to respond_to( :json )
    end
    
  end

  # ------------------------------------------------------------------
  # ddoc
  describe "ddoc" do

    context "no tags" do

      let (:content ) {         
         lines = <<-EOS
             line1
             line2
         EOS
      }

      it "#no output" do

        pattern = "*.*"
        filename = "apu/ko/file.name"

        expect( Dir ).to receive( :glob ).with( pattern ).and_return( [filename] )
        expect( File ).to receive( :readlines ).with( filename ).and_return(  content.scan( /[^\n]*\n/  )  )
        output = with_captured_stdout( ) { @sut.ddoc( pattern )}
        expect( output ).to eql ""
      end
    end # no output

    # --------------------
    # context open tag is tehere
    
    context "tags there" do

      let (:tagged ) { "tagged line" }
      
      let (:content ) {         
         lines = <<-EOS
             line1
             +++start+++
               #{tagged}
             +++close+++
             line2
         EOS
      }


      it "#output tagged" do
        output = "hei"
        pattern = "*.*"
        filename = "apu/ko/file.name"
        expect( Dir ).to receive( :glob ).with( pattern ).and_return( [filename] )
        # keep separators
        expect( File ).to receive( :readlines ).with( filename ).and_return(  content.scan( /[^\n]*\n/  )  )

        output = with_captured_stdout() { @sut.ddoc( pattern ) }
        expect( output ).to match( tagged )
      end

    end # no output

  end

end
