module Callbacks
  module InstanceMethods
    
    def callbacks(show_classvars = true)
      return self.instance_callbacks if show_classvars == false
      return self.class_callbacks + self.instance_callbacks if show_classvars == true
    end
  
    def add_callbacks(*callbacks)
      callbacks.each do |calbacks|
        self.add_callback(callback)
      end
    end
  
    def add_callback(callback)
      self.callbacks(false) << callback
    end
    
    #Really don't know what this does :p But it works!
    #I'm really, really bad at metaprogramming
    def callbacks_for(method, type)
      begin
        return self.callback_actions[method] if type.nil?
        return self.callback_actions[method][type] ||= []
      rescue NoMethodError
        return []
      end
    end
    
    def class_callbacks
      self.class.callbacks
    end
    
    def instance_callbacks
      @callbacks ||= []
    end

    def trigger_callbacks(method, type)
    
      self.callbacks_for(method, type).each do |callback|
        callback.call
      end
    
      #Should I return something?
    end
  end
end