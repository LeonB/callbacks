require 'test/test_helper'

class ClassCallbacksTest < Test::Unit::TestCase
  def setup
    Object.send(:remove_const, :Tester) if defined? Tester
    load 'test/tester_class.rb'
    $tests_run = []
  end
  
  def test_class_method_should_not_throw_exceptions
    assert_nothing_raised(Exception) do
      Tester.add_class_callback_methods :boot
    end 
  end
  
  def test_class_method_should_not_use_instance_methods
    #Do not use exit, this is a private method every class has :P
    
    assert_raise(NameError) do
      Tester.add_class_callback_methods :testing
    end 
  end
end