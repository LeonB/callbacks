module Callbacks
  module InstanceMethods
    
    def callback_actions(show_classvars = true)
      callback_actions = self.class_callback_actions
      #return self.instance_callbacks if show_classvars == false
      #return self.class_callback_actions + self.instance_callback_actions if show_classvars == true
    end
    
    def callback_actions_for(method, type)  
      #Do the rescue if [method] does not exist (nil), [type] will fail
      begin
        callback_actions = self.callback_actions[method][type] ||= []
      rescue NoMethodError
        callback_actions = []
      end
      
      #If the before/after_ method exists, and it is not already added,
      # add it!
      #Dit kan mooier!
      if self.respond_to?("#{type}_#{method}")
        if not callback_actions.include? "#{type}_#{method}".to_sym
          #callback_actions << Callback.new(method, "#{type}_#{method}".to_sym)
          callback = self.class.add_callback_action(type, method, "#{type}_#{method}".to_sym)
          callback_actions << callback
        end
      end
      
      return callback_actions
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
