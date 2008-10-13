module Callbacks
  module InstanceMethods
    
    def trigger_callback_actions(method, type)
      trigger_class_callback_actions(method, type) if self.class.respond_to?(:callback_actions_for)
      trigger_metaclass_callback_actions(method, type) if self.metaclass.respond_to?(:callback_actions_for)
      #Should I return something?
    end
    
    #TODO: do something with a block or proc or something :p
    #Instead of self.class/self.metaclass
    def trigger_class_callback_actions(method, type)
      self.class.callback_actions_for(method, type).each do |callback|
        
        if callback.block
          self.instance_eval(&callback.block)
        else
          callback.proc.call
        end
      end
      
      #I'm not happy with this...
      if self.respond_to?("#{type}_#{method}")
        self.send("#{type}_#{method}")
      end
    end
    
    def trigger_metaclass_callback_actions(method, type)
      self.metaclass.callback_actions_for(method, type).each do |callback|
        
        if callback.block
          return self.instance_eval(&callback.block)
        else
          callback.proc.call
        end
      end
      #Should I return something?
    end

  end #InstanceMethods
end #Callbacks
