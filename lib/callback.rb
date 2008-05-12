class Callback
  attr_accessor :method, :input, :proc
  
  def initalize(method, input)
    self.method = method
    self.input = input
  end
  
  def call
    generate_proc if self.proc.nil? #The first time it gets generated, then just called()
    self.proc.call()
  end
  
  def generate_proc
    self.proc = case self.input
    when Symbol
      Proc.new { self.send(callback) }
      raise 'How to handel symbols?'
    when String
      Proc.new { eval self.input }
    when Proc, Method
      self.input
    else
      if self.input.respond_to?(self.method)
        Proc.new { callback.send(method, self) }
      else
        raise "Callbacks must be a symbol denoting the method to call, a string to be evaluated, a block to be invoked, or an object responding to the callback method. #{self.input} is none of those."
      end
    end
  end
end