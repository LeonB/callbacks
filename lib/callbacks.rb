#Idea stolen from rails/activerecord
module Callbacks
  LIBPATH = ::File.expand_path(::File.dirname(__FILE__)) + ::File::SEPARATOR
  PATH = ::File.dirname(LIBPATH) + ::File::SEPARATOR
  
  require 'observer'
  require "#{PATH}/ext/metaid.rb"
  require 'callbackchain.rb'
  require 'instancemethods.rb'
  require 'classmethods.rb'
  require 'callback.rb'
  
  #Sets all things right
  def self.included(base) #:nodoc:
    base.extend Callbacks::ClassMethods
    base.send(:include, Callbacks::InstanceMethods)
  end
  
  def self.version
    VERSION
  end

  def self.libpath( *args )
    args.empty? ? LIBPATH : ::File.join(LIBPATH, *args)
  end

  def self.path( *args )
    args.empty? ? PATH : ::File.join(PATH, *args)
  end
  
end

#TODO: add aliases like add_hook(), callbacks(), et cetera
#TODO: make all of the activesupport features/tests work
