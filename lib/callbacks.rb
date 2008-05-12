#Stolen from rails/activerecord
#TODO: look at 
# http://coderepos.org/share/browser/lang/ruby/pritter/vendor/xmpp4r/lib/xmpp4r/callbacks.rb
module Callbacks
  require 'observer'
  require 'instancemethods.rb'
  require 'classmethods.rb'
  
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