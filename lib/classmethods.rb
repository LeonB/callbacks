module Callbacks
  module ClassMethods
    
    def callbacks()
      @@callbacks ||= []
    end
    
    def callback_actions()
      @@callback_actions ||= {}
    end
  
    def add_callback_methods(*callbacks)
      callbacks.each do |callback|
        self.add_callback_method(callback)
      end
    end
    alias_method(:add_callbacks, :add_callback_methods)
  
    #add_callback
    def add_callback_method(callback)
      self.callbacks << callback
      self.build_callback_method(callback)
    end
    alias_method(:add_callback, :add_callback_method)
    
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
          trigger_callbacks(method, :before)
          self.send("#{method}_without_callbacks")
          trigger_callbacks(method, :after)
        end
      end
      
      send :alias_method, "#{method}_without_callbacks", method
      send :alias_method, method, "#{method}_with_callbacks"
    end
    
    def add_callback_action(type, method, code, &block)
      ca = self.callback_actions
      
      ca[method] = {} if ca[method].nil?
      ca[method][type] = [] if ca[method][type].nil?
      
      ca[method][type] << Callback.new(method, code, &block)
    end
    
    def callbacks_for(method, type = nil)
      begin
        return self.callback_actions[method] if type.nil?
        return self.callback_actions[method][type] ||= []
      rescue NoMethodError
        return []
      end
    end
    
  end
end