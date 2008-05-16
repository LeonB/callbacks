module Callbacks
  module ClassMethods
    
    def callback_methods
      @@callback_methods ||= []
    end 
   
    def callback_actions
      @@callback_actions ||= {}
    end
   
    def add_callback_methods(*callbacks)
      callbacks.each do |callback|
        self.callback_methods << callback.to_sym
        self.build_callback_method(callback)
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
    
    def build_callback_method(method)
        
      #instance_eval do
      instance_eval <<-"end_eval"

          def before_#{method}(*callbacks, &block)
            add_callback_action :before, :#{method}, *callbacks, &block
          end

          def after_#{method}(*callbacks, &block)
            add_callback_action :after, :#{method}, *callbacks, &block
          end

      end_eval
      #end
      
      class_eval do
        define_method "#{method}_with_callbacks" do
          trigger_callback_actions(method, :before)
          self.send("#{method}_without_callbacks")
          trigger_callback_actions(method, :after)
        end
      end
      
      send :alias_method, "#{method}_without_callbacks", method
      send :alias_method, method, "#{method}_with_callbacks"
    end

    def add_callback_action(type, method, *code, &block)
      ca = self.callback_actions
      
      ca[method] = {} if ca[method].nil?
      ca[method][type] = [] if ca[method][type].nil?
      
      if block_given?
        ca[method][type] << Callback.new(method, nil, &block)
      else
        code.each do |c|
          ca[method][type] << Callback.new(method, c)
        end
      end
    end
    
    def callback_actions_for(method, type = nil)
      begin
        return self.callback_actions[method] if type.nil?
        return self.callback_actions[method][type] ||= []
      rescue NoMethodError
        return []
      end
    end
    
  end
end