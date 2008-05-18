class Callback
  attr_accessor :method, :input
  attr_writer :proc
  ACCEPTED = [Symbol, Proc, String, Method]
  
  def initialize(method, input, &block)
    #self.method = method
    self.input = input
    self.input = block if block_given?
    
    if not ACCEPTED.include? self.input.class
      raise "Callbacks must be a symbol denoting the method to call, a string to be evaluated, a block to be invoked, or an object responding to the callback method. #{self.input} is none of those."
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
    #else if self.input.respond_to?(self.method)
    #    Proc.new { callback.send(method, self) }
    #  end
    end
  end
  
  def generate_block
    case self.input
    when Symbol
      symbol = self.input.to_sym
      Proc.new { self.send(symbol) }
    when Proc, Method
      self.input
    end
  end
end