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
    
    def build_callback_methods(method)
      build_before_callback_method(method)
      build_after_callback_method(method)
      
      class_eval <<-"end_eval"
        def #{method}_with_callbacks
          trigger_callback_actions(:#{method}, :before)
          retval = self.send("#{method}_without_callbacks")
          trigger_callback_actions(:#{method}, :after)
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
    
    private
    def build_before_callback_method(method)
      instance_eval <<-"end_eval"
      
          def before_#{method}(*callbacks, &block)
            add_callback_action :before, :#{method}, *callbacks, &block
          end

      end_eval
    end
    
    def build_after_callback_method(method)
      instance_eval <<-"end_eval"

          def after_#{method}(*callbacks, &block)
            add_callback_action :after, :#{method}, *callbacks, &block
          end

      end_eval
    end
    
  end
end