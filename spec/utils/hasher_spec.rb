# hasher_spec.rb - test rpsec framework

require File.join File.dirname(__FILE__), ".." , "spec_helper.rb" 

# require 'marshal'
require 'utils/hasher'


class Tst
  include ::Utils::Hasher
end

describe "Utils::Hasher" do


  before :each do
    @sut = Tst.new
  end


  # ------------------------------------------------------------------
  # interface

  describe "interface" do


    it "#defines method 'addComma'" do
      expect( @sut ).to respond_to( :addComma )
    end 

  end # interface

  # ------------------------------------------------------------------
  # addCommad

  describe ".addComma" do


    it "#no changes for {} (=emtpy hash)" do
      input = {}
      output = input
      expect( @sut.addComma(input) ).to eql( output )
    end 

    it "#no changes for 'nil' object" do
      input = nil
      output = input
      expect( @sut.addComma(input) ).to eql( output )
    end 

    it "#no changes for array of string" do
      input = {
        "apu1" => "koe1",
        "apu2" => [ "koe2", "Hellow" ]
      }
      output =  Marshal.load(Marshal.dump(input))
      # output["apu2"][0]["_comma"]=','
      expect( @sut.addComma(input) ).to eql( output )
    end 


    it "#adds comma to array hashes (not to last element)" do
      input = {
        "apu1" => "koe1",
        "apu2" => [ 
                   { "koe2" => "Hello2" },
                   { "koe3" => "Hello3" } 
                  ]
      }
      output =  Marshal.load(Marshal.dump(input))
      output["apu2"][0]["_comma"]=','
      # output["apu2"][1]["_comma"]=','
      expect( @sut.addComma(input) ).to eql( output )
    end 

    it "#adds comma to array hashes - in multiple arrays" do
      input = {
        "apu1" => "koe1",
        "apu2" => [ 
                   { "koe2" => "Hello2" },
                   { "koe3" => "Hello3" } 
                  ],
        "apu3" => [ 
                   { "koe3.1" => "Hello3.1" },
                   { "koe3.2" => "Hello3.2" } 
                  ]
      }
      output =  Marshal.load(Marshal.dump(input))
      output["apu2"][0]["_comma"]=','
      output["apu3"][0]["_comma"]=','
      expect( @sut.addComma(input) ).to eql( output )
    end 

    it "#no comma if only on element in array" do
      input = {
        "apu1" => "koe1",
        "apu2" => [ 
                   { "koe2" => "Hello2" },
                  ]
      }
      output =  Marshal.load(Marshal.dump(input))
      # output["apu2"][0]["_comma"]=','
      # output["apu2"][1]["_comma"]=','
      expect( @sut.addComma(input) ).to eql( output )
    end 

    it "#adds comma to array hashes deep in hash" do
      input = {
        "apu1" => "koe1",
        "level1" => {
          "apu2" => [ 
                     { "koe2" => "Hello2" },
                     { "koe3" => "Hello3" } 
                    ]
          }
      }
      output =  Marshal.load(Marshal.dump(input))
      output["level1"]["apu2"][0]["_comma"]=','
      # output["level1"]["apu2"][1]["_comma"]=','
      expect( @sut.addComma(input) ).to eql( output )
    end 



    # it "#no changes for if no arrays " do
    #   input = {
    #       "apu" => [ "koe" ]
    #   }
    #   output = input
    #   expect( @sut.addComma(input) ).to eql( output )
    # end 


    
  end # addCommand



end # 
