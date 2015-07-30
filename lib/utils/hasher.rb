# see http://hawkins.io/2013/08/using-the-ruby-logger/

# ------------------------------------------------------------------
# Open up class Hash to add `deep_traverse`


class Hash 
  def deep_traverse(&block)
    self.each do |k,v|
      puts k,v
      yield( k,v)
    end
  end
  #   stack = self.map{ |k,v| [ [k], v ] }
  #   while not stack.empty?
  #     key, value = stack.pop
  #     yield(key, value)
  #     if value.is_a? Hash
  #       value.each{ |k,v| stack.push [ key.dup << k, v ] }
  #     end
  #   end
  # end

end



# ------------------------------------------------------------------
# implement my own 

module Utils

  module Hasher

    # see http://stackoverflow.com/questions/3748744/traversing-a-hash-recursively-in-ruby

    def dfs(hsh, &blk)
      return enum_for(:dfs, hsh) unless blk

      # no change unless a hash
      return hsh unless hsh.is_a? Hash

      yield hsh
      hsh.each do |k,v|
        if v.is_a? Array
          v.each do |elm|
            dfs(elm, &blk)
          end
        elsif v.is_a? Hash
          dfs(v, &blk)
        end
      end
      return hsh
      # nil
    end

    # adds comma hash in arrays deeply in obj-hash
    def addComma( obj )

      if ( obj.is_a?(Hash) ) 

        obj2 = dfs(obj) do |o| 
          o.each do |k,v| 
            if v.is_a? Array
              # add _comma = ',', expect to the 
              v.slice(0,v.length-1).each do |elem|
                elem["_comma"] = "," if elem.is_a? Hash
              end
              # add _comma = '' to the last element
              v.last["_comma"] = "" if  v.last.is_a? Hash
            end
          end
        end # block

        obj = obj2

      end

      
      return obj
    end

  end

end # module Utils
