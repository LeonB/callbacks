#Idea stolen from rails/activerecord
module Callbacks
  require 'observer'
  require 'ext/metaid.rb'
  require 'callbackchain.rb'
  require 'instancemethods.rb'
  require 'classmethods.rb'
  require 'callback.rb'

  #Sets all things right
  def self.included(base) #:nodoc:
    base.extend Observable #why?
    base.extend Callbacks::ClassMethods
    base.send(:include, Callbacks::InstanceMethods)
  end
end

#TODO: add aliases like add_hook(), callbacks(), et cetera
#TODO: feature to add hooks/callbacks to instances instead of only classes
#TODO: make all of the activesupport features/tests work
