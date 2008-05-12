module Callbacks
  module ClassMethods
    #attr_accessor :callbacks
    def callbacks
      @@callbacks ||= {}
    end
    
    def callbacks=(arg)
      @@callbacks=arg
    end
    
    def add_callbacks(*args)
      args.each do |arg|
        arg = arg.to_sym
        CALLBACKS << arg
        init_callback_method(arg)
      end
    end
    
    def init_callback_method(method)
      
      #You can't use meta_def OR define_method, because in ruby1.8 a block can't accept block parameters
      #This is changed in 1.9
        
      instance_eval do
      class_eval <<-"end_eval"

        def before_#{method}(*callbacks, &block)
          add_callback :before, :#{method}, *callbacks, &block
        end

        def after_#{method}(*callbacks, &block)
          add_callback :after, :#{method}, *callbacks, &block
        end

      end_eval
      end
      
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
    
    def callbacks_for(method, type = nil)
      begin
        return self.callbacks[method] if type.nil?
        return self.callbacks[method][type] ||= []
      rescue NoMethodError
        return []
      end
    end
    
    def add_callback(type, method, *args, &block)
      callbacks = self.callbacks
      
      callbacks[method] = {} if callbacks[method].nil?
      callbacks[method][type] = [] if callbacks[method][type].nil?
      
      if args.empty? && block.nil?
        raise ArgumentError, "please specify either a task name or a block to invoke"
      elsif args.any? && block
        raise ArgumentError, "please specify only a task name or a block, but not both"
      elsif block_given?
        callbacks[method][type] << block
      else
        args.each do |arg|
          callbacks[method][type] << arg
        end
      end
    end 
  end
end