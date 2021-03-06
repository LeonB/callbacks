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

      #TODO: order by options[:priority]
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

    def add_callback_action(type, method, callback_code = nil, options = {}, &block)
      ca = self.callback_actions
      
      ca[method] = {} if ca[method].nil?
      ca[method][type] = [] if ca[method][type].nil?
      
      if block_given?
        callback = Callback.new(method, nil, options, &block)
      elsif not callback_code.nil?
        callback = Callback.new(method, callback_code, options)
      else
        raise 'No block and callback_code given'
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

          def self.#{type}_#{method}(callback_code = nil, options = {}, &block)
            add_callback_action(:#{type}, :#{method}, callback_code, options, &block)
          end

      end_eval
      module_eval(method)
    end
    
    ###### Specific class callback stuff
    def add_class_callback_methods(*callback_methods)
      self.meta_eval do
        if not respond_to?(:add_callback_methods)
          include Callbacks
        end
        
        self.add_callback_methods(*callback_methods)
      end
    end
    
  end
end