module Callbacks
  module InstanceMethods
    
    def callback_actions(show_classvars = true)
      return self.class_callback_actions
      #return self.instance_callbacks if show_classvars == false
      #return self.class_callback_actions + self.instance_callback_actions if show_classvars == true
    end
    
    #Really don't know what this does :p But it works!
    #I'm really, really bad at metaprogramming
    def callback_actions_for(method, type)
      begin
        return self.callback_actions[method] if type.nil?
        return self.callback_actions[method][type] ||= []
      rescue NoMethodError
        return []
      end
    end
    
    def class_callback_actions
      self.class.callback_actions
    end

    def trigger_callback_actions(method, type)
      
      self.callback_actions_for(method, type).each do |callback|
        if callback.block
          return instance_eval(&callback.block)
        else
          callback.proc.call
        end
      end
    
      #Should I return something?
    end
  end
end