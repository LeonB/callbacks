module Callbacks
  module ClassMethods
    
    def callback_methods  
      #Use one @, else it gets stored in the module and then it will be avaiable in every class that uses callback
      @callback_methods ||= []
    end 
   
    def callback_actions
      #Use one @, else it gets stored in the module and then it will be avaiable in every class that uses callback
      @callback_actions ||= CallbackChain.new
    end
   
    def add_callback_methods(*callbacks)
      callbacks.each do |callback|
        self.callback_methods << callback.to_sym
        self.build_callback_methods(callback)
      end
    end
    
    def remove_callback_method(method)      
      self.meta_eval do
        remove_method("before_#{method}")
        remove_method("after_#{method}")
      end
      
      remove_method("#{method}_with_callbacks")
      remove_method(method) #This is the method_with_callbacks
      alias_method(method, "#{method}_without_callbacks")
      self.callback_methods.delete(method.to_sym)
    end
    
    #TODO: make this nicer      
    def callback_actions_for(method, type)
      if self.callback_actions[method].nil?
        callback_actions = []
      else
        callback_actions = self.callback_actions[method][type] ||= []
      end
      
#Removed this because this didn't work
#callback_actions_for is called four times with every callback method:
# before, before metaclass, after, after metaclass
# And a class and metaclass both now the #{type}_#{method} method
# So it got called twice
#      if self.instance_methods.include?("#{type}_#{method}")
#        if not callback_actions.include? "#{type}_#{method}".to_sym
#          callback = self.add_callback_action(type, method, "#{type}_#{method}".to_sym)
#          callback_actions << callback
#        end
#      end
      
      return callback_actions 
    end
    
    def build_callback_methods(method)
      build_before_callback_method(method)
      build_after_callback_method(method)
      
      class_eval <<-"end_eval"
        def #{method}_with_callbacks
          self.trigger_callback_actions(:#{method}, :before) 
          retval = self.send("#{method}_without_callbacks")
          self.trigger_callback_actions(:#{method}, :after)
          return retval
        end
      end_eval
      
      send :alias_method, "#{method}_without_callbacks", method
      send :alias_method, method, "#{method}_with_callbacks"
    end

    def add_callback_action(type, method, *code, &block)
      ca = self.callback_actions
      
      ca[method] = {} if ca[method].nil?
      ca[method][type] = [] if ca[method][type].nil?
      
      if block_given?
        callback = Callback.new(method, nil, &block)
      else
        code.each do |c|
          callback = Callback.new(method, c)
        end
      end
      ca[method][type] << callback
      return callback
    end
   
    def build_before_callback_method(method)
      build_callback_method(:before, method)
    end
    
    def build_after_callback_method(method)
      build_callback_method(:after, method)
    end
    
    def build_callback_method(type, method)
      method = <<-"end_eval"

#          def #{type}_#{method}(*callbacks, &block)
#            self.class.add_callback_action(:#{type}, :#{method}, *callbacks, &block)
#          end

          def self.#{type}_#{method}(*callbacks, &block)
            add_callback_action(:#{type}, :#{method}, *callbacks, &block)
          end

      end_eval
      module_eval(method)
    end
    
  end
end