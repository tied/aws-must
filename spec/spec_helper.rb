# spec_helper.rb

# My app
libdir = File.join File.dirname(__FILE__), '../lib'
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)
