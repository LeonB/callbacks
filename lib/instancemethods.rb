module Callbacks
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
end