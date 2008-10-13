class Callback
  attr_accessor :method, :input
  attr_writer :proc
  ACCEPTED = [Symbol, Proc, String, Method]
  ACCEPTANCE_ERROR = "Callbacks must be a symbol denoting the method to call, a string to be evaluated, a block to be invoked, or an object responding to the callback method. %s is none of those."
  
  def initialize(method, input, &block)
    self.input = input
    self.input = block if block_given?
    
    if not ACCEPTED.include? self.input.class
      raise ACCEPTANCE_ERROR % self.input.class
    end
  end
  
  def proc
    @proc ||= self.generate_proc
  end
  
  def block
    @block ||= self.generate_block
  end
  
  def generate_proc
    case self.input
    when String
      Proc.new { eval(self.input) }
    else
      nil
    end
  end
  
  def generate_block
    case self.input
    when Symbol
      instance_method = self.input.to_sym
      Proc.new { self.send(instance_method) }
    when Proc, Method
      self.input
    else
      nil
    end
  end
end