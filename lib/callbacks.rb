#Stolen from rails/activerecord
#TODO: look at 
# http://coderepos.org/share/browser/lang/ruby/pritter/vendor/xmpp4r/lib/xmpp4r/callbacks.rb
module Callbacks
  require 'observer'
  
  #  CALLBACKS = [
  #    'song_halfway',
  #    'song_end',
  #    'boot',
  #    'shutdown',
  #  ]
  
  CALLBACKS = []
  
  module InstanceMethods
    #Really don't know what this does :p But it works!
    #I'm really, really bad at metaprogramming
    def callbacks_for(method, type)
      
      self.class.class_eval do
        callbacks_for(method, type)
      end
    end

    def trigger_callbacks(method, type)
    
      self.callbacks_for(method, type).each do |callback|
      
        result = case callback
        when Symbol
          self.send(callback)
        when String
          eval(callback, binding)
        when Proc, Method
          callback.call(self)
        else
          if callback.respond_to?(method)
            callback.send(method, self)
          else
            raise "Callbacks must be a symbol denoting the method to call, a string to be evaluated, a block to be invoked, or an object responding to the callback method."
          end
        end
      end
    
      #Should I return something?
    end
  end
  
  module ClassMethods
    #attr_accessor :callbacks
    def callbacks
      @@callbacks ||= {}
    end
    
    def callbacks=(arg)
      @@callbacks=arg
    end
    
    def add_callback_methods(*args)
      args.each do |arg|
        arg = arg.to_sym
        CALLBACKS << arg
        init_callback_method(arg)
      end
    end
    
    def init_callback_method(method)
      
      #You can't use meta_def OR define_method, because in ruby1.8 a block can't accept block parameters
      #This is changed in 1.9
        
      meta_eval do
        class_eval <<-"end_eval"
 
           def before_#{method}(*callbacks, &block)
              add_callback :before, :#{method}, *callbacks, &block
            end

            def after_#{method}(*callbacks, &block)
              add_callback :after, :#{method}, *callbacks, &block
            end
        end_eval
      end
      
      class_eval do
        define_method "#{method}_with_callbacks" do
          trigger_callbacks(method, :before)
          self.send("#{method}_without_callbacks")
          trigger_callbacks(method, :after)
        end
      end
      
      send :alias_method, "#{method}_without_callbacks", method
      send :alias_method, method, "#{method}_with_callbacks"
    end
    
    def callbacks_for(method, type = nil)
      begin
        return self.callbacks[method] if type.nil?
        return self.callbacks[method][type] ||= []
      rescue NoMethodError
        return []
      end
    end
    
    def add_callback(type, method, *args, &block)
      callbacks = self.callbacks
      
      callbacks[method] = {} if callbacks[method].nil?
      callbacks[method][type] = [] if callbacks[method][type].nil?
      
      if args.empty? && block.nil?
        raise ArgumentError, "please specify either a task name or a block to invoke"
      elsif args.any? && block
        raise ArgumentError, "please specify only a task name or a block, but not both"
      elsif block_given?
        callbacks[method][type] << block
      else
        args.each do |arg|
          callbacks[method][type] << arg
        end
      end
    end 
  end

  #Sets all things right
  def self.included(base) #:nodoc:
    base.extend Observable
    base.extend Callbacks::ClassMethods
    base.send(:include, Callbacks::InstanceMethods)
  end
end