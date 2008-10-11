module Callbacks
  module InstanceMethods
    
    def callback_actions(show_classvars = true)
      self.class_callback_actions
    end
    
    def callback_actions_for(method, type)
      self.class_callback_actions_for(method, type)
    end
    
    def class_callback_actions
      callback_actions.merge!(self.class.callback_actions)
    end
    
    def class_callback_actions_for(method, type)
      self.class.callback_actions_for(method, type)
    end
    
    def trigger_callback_actions(method, type)
      self.callback_actions_for(method, type).each do |callback|
        
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
    
      trigger_metaclass_callback_actions(method, type)
      #Should I return something?
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
    
  end

end
