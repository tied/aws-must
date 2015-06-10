
require File.join File.dirname(__FILE__), ".." , "spec_helper.rb" 

# SUT
require 'aws-must'


describe "AwsMust::Docu" do



  # ------------------------------------------------------------------
  # setup

  before :each do

    @template    =  double( "template" )
    @sut         = ::AwsMust::Docu.new( @template )

  end


  # ------------------------------------------------------------------
  # interface


  describe "interface" do

    it "#defines method 'document'" do
      expect( @sut ).to respond_to( :document )
    end 

    it "#defines method 'output'" do
      expect( @sut ).to respond_to( :output )
    end 

    it "#defines method 'directive_open'" do
      expect( @sut ).to respond_to( :directive_open )
    end 

    it "#defines method 'directive_close'" do
      expect( @sut ).to respond_to( :directive_close )
    end 

    it "#defines method 'directive_include'" do
      expect( @sut ).to respond_to( :directive_include )
    end 



  end # interface

  
  # ------------------------------------------------------------------
  # 

  describe "method 'document'" do


    describe "only on root template" do


      it "#nil string --> no output" do
        root =  nil

        expect( @template ).to receive( :get_template ).and_return( root )
        expect( @sut ).not_to receive( :output )
        expect( @sut ).not_to receive( :directive_open )
        expect( @sut ).not_to receive( :directive_close )
        expect( @sut ).not_to receive( :directive_include )
        
        @sut.document( "root" )

      end

      it "#no ':open' directive --> no output" do

        line="aaa"
        root =  <<MUSTACHE
#{line}
MUSTACHE

        expect( @template ).to receive( :get_template ).and_return( root )

        expect( @sut ).not_to receive( :output )
        expect( @sut ).to receive( :directive_open ).with( line )
        expect( @sut ).not_to receive( :directive_close )
        expect( @sut ).not_to receive( :directive_include )
        
        @sut.document( "root" )


      end

      it "#no ':open' directive, two lines --> no output'" do

        line1="Line1"
        line2="Line2 in template"
        root =  <<MUSTACHE
#{line1}
#{line2}
MUSTACHE

        expect( @template ).to receive( :get_template ).and_return( root )

        expect( @sut ).not_to receive( :output )
        expect( @sut ).to receive( :directive_open ).twice
        expect( @sut ).not_to receive( :directive_close )
        expect( @sut ).not_to receive( :directive_include )
        
        @sut.document( "root" )


      end

      it '#case l\nO\nL\n --> output L' do

        line1="line1"
        line2="Line2"
        root =  <<MUSTACHE
#{line1}
#{@sut.get_tag(:open)}
#{line2}
MUSTACHE

        expect( @template ).to receive( :get_template ).and_return( root )

        expect( @sut ).to receive( :output ).with( line2 )
        expect( @sut ).to receive( :directive_close ).with( line2 ).and_call_original
        
        @sut.document( "root" )

      end

      it '#case O\n\nL\n --> output L' do

        line1="line1"
        line2="Line2"
        root =  <<MUSTACHE

#{@sut.get_tag(:open)}

#{line1}
MUSTACHE

        expect( @template ).to receive( :get_template ).and_return( root )

        expect( @sut ).to receive( :output ).with( "" ).ordered
        expect( @sut ).to receive( :output ).with( line1 ).ordered
        
        @sut.document( "root" )

      end



      it '#case lOL\n  --> output L' do

        line1="line1"
        line2="line2"
        root =  <<MUSTACHE
#{line1}#{@sut.get_tag(:open)}#{line2}
MUSTACHE

        expect( @template ).to receive( :get_template ).and_return( root )

        # expect( @sut ).to receive( :output ).with( line2 )
        expect( @sut ).not_to receive( :output )
        
        @sut.document( "root" )

      end



      it '#case l\nO\nL\nL\n' do

        line1="aaa"
        line2="bbb"
        line3="ccc"
        root =  <<MUSTACHE
#{line1}
#{@sut.get_tag(:open)}
#{line2}
#{line3}
MUSTACHE

        expect( @template ).to receive( :get_template ).and_return( root )

        expect( @sut ).to receive( :output ).twice
        expect( @sut ).to receive( :directive_close ).twice.and_call_original
        
        @sut.document( "root" )

      end

      it '#case lOL\n' do

        line1="aaa"
        line2="bbb"
        line3="ccc"
        root =  <<MUSTACHE
#{line1}#{@sut.get_tag(:open)}#{line2}
#{line3}
MUSTACHE

        expect( @template ).to receive( :get_template ).and_return( root )

        expect( @sut ).to receive( :output ).with( line3 )
        expect( @sut ).to receive( :directive_close ).once.and_call_original
        
        @sut.document( "root" )

      end



      it '#case l\nO\nL\nC\nl\n' do

        root_name="myroot_template_name"

        line1="line1"
        line2="Line2 for case lOLCl"
        line3="line3"
        root =  <<MUSTACHE
#{line1}
#{@sut.get_tag(:open)}
#{line2}
#{@sut.get_tag(:close)}
#{line3}
MUSTACHE

        expect( @template ).to receive( :get_template ).and_return( root )

        expect( @sut ).to receive( :output ).with( line2 )
        expect( @sut ).to receive( :directive_close ).twice.and_call_original
        
        @sut.document( root_name )

      end

      it '#case lO\nLC\nll  -> ouput L' do

        root_name="myroot_template_name"

        line1="line1"
        line2="line2"
        line3="line3"
        root =  <<MUSTACHE
#{line1}#{@sut.get_tag(:open)}
#{line2}#{@sut.get_tag(:close)}
#{line3}
MUSTACHE

        expect( @template ).to receive( :get_template ).and_return( root )

        #expect( @sut ).to receive( :output ).with( line2 )
        expect( @sut ).not_to receive( :output )

        
        @sut.document( root_name )

      end

      it '#case lOLC\nl  -> ouput L' do

        root_name="myroot_template_name"

        line1="line1"
        line2="line2"
        line3="line3"
        root =  <<MUSTACHE
#{line1}#{@sut.get_tag(:open)}#{line2}#{@sut.get_tag(:close)}
#{line3}
MUSTACHE

        expect( @template ).to receive( :get_template ).and_return( root )

        expect( @sut ).to receive( :output ).with( line3 )
        
        @sut.document( root_name )

      end

      it '#case lOLClOL\n  -> ouput L' do

        root_name="myroot_template_name"

        line1="line1"
        line2="line2"
        line3="line3"
        line4="line4"
        root =  <<MUSTACHE
#{line1}#{@sut.get_tag(:open)}#{line2}#{@sut.get_tag(:close)}#{line3}#{@sut.get_tag(:open)}#{line4}
MUSTACHE

        expect( @template ).to receive( :get_template ).and_return( root )

        # expect( @sut ).to receive( :output ).with( line2 )
        # expect( @sut ).to receive( :output ).with( line4 )
        expect( @sut ).not_to receive( :output )
        
        @sut.document( root_name )

      end



      it '#case lOLCl\n  -> ouput L' do

        root_name="myroot_template_name"

        line1="line1"
        line2="line2"
        line3="line3"
        root =  <<MUSTACHE
#{line1}#{@sut.get_tag(:open)}#{line2}#{@sut.get_tag(:close)}#{line3}
MUSTACHE

        expect( @template ).to receive( :get_template ).and_return( root )

        expect( @sut ).not_to receive( :output )
        
        @sut.document( root_name )

      end


      it '#case c\nl\nO\nL\nC\nl\n' do

        root_name="myroot_template_name"

        line1="aaa"
        line2="bbb"
        line3="ccc"
        root =  <<MUSTACHE
#{@sut.get_tag(:close)}
#{line1}
#{@sut.get_tag(:open)}
#{line2}
#{@sut.get_tag(:close)}
#{line3}
MUSTACHE

        expect( @template ).to receive( :get_template ).with( root_name ).and_return( root )

        expect( @sut ).to receive( :output ).with( line2 )
        
        @sut.document( root_name )

      end


      it '#case c\nl\nO\no\nL\nC\nl\n' do

        line1="aaa"
        line2="bbb"
        line3="ccc"
        root =  <<MUSTACHE
#{@sut.get_tag(:close)}
#{line1}
#{@sut.get_tag(:open)}
#{@sut.get_tag(:open)}
#{line2}
#{@sut.get_tag(:close)}
#{line3}
MUSTACHE

        expect( @template ).to receive( :get_template ).and_return( root )

        # output in correct order
        expect( @sut ).to receive( :output ).with( @sut.get_tag(:open) ).ordered
        expect( @sut ).to receive( :output ).with( line2 ).ordered
        
        @sut.document( "root" )

      end

    end # describe "only on root template" do


    
  end # method 'document'

  describe "include template" do


      it '#case clOLiOLCLCl' do

      line1_1="1_1"
      line1_2="1_2"
      template1="template1"
      line1_3="1_3"
      line1_4="1_4"
      
      line2_1="2_1"
      line2_2="2_2"
      line2_3="2_3"

        root =  <<MUSTACHE
#{line1_1}
#{@sut.get_tag(:open)}
#{line1_2}
#{@sut.get_tag(:include)} #{template1}
#{line1_3}
#{@sut.get_tag(:close)}
#{line1_4}
MUSTACHE

        mustache1 =  <<MUSTACHE
#{line2_1}
#{@sut.get_tag(:open)}
#{line2_2}
#{@sut.get_tag(:close)}
#{line2_3}
MUSTACHE


        expect( @template ).to receive( :get_template ).and_return( root, mustache1 )

        # output in correct order
        expect( @sut ).to receive( :output ).with( line1_2 ).ordered
        expect( @sut ).to receive( :output ).with( line2_2 ).ordered
        expect( @sut ).to receive( :output ).with( line1_3 ).ordered
        
        @sut.document( "root" )

      end

  end

  # ------------------------------------------------------------------
  # directive_include

  describe "method 'directive_include'" do

    it "returns 'nil' for nil input" do

      expect( @sut.directive_include( nil )).to eql( nil )
    
    end

    it "returns 'nil' if 'line' does not match input directive" do
      line = ""
      expect( @sut.directive_include( line )).to eql( nil )
    end

    it "returns 'template' if 'line' matches include directive" do

      template_name="mytemplate"
      line = "#{@sut.get_tag(:include)} #{template_name}"
      expect( @sut.directive_include( line )).to eql( template_name )
    end


  end

end 



