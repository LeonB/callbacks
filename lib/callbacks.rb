#Idea stolen from rails/activerecord
module Callbacks
  require 'observer'
  require 'ext/metaid.rb'
  require 'instancemethods.rb'
  require 'classmethods.rb'
  require 'callback.rb'
  
  #  CALLBACKS = [
  #    'song_halfway',
  #    'song_end',
  #    'boot',
  #    'shutdown',
  #  ]
  
  CALLBACKS = []

  #Sets all things right
  def self.included(base) #:nodoc:
    base.extend Observable
    base.extend Callbacks::ClassMethods
    base.send(:include, Callbacks::InstanceMethods)
  end
end

#TODO: add aliases like add_hook(), callbacks(), et cetera
#TODO: feature to add hooks/callbacks to instances instead of only classes