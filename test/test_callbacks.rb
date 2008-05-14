class CallbacksTest < Test::Unit::TestCase
  
  def test_should_create_callbacks_in_class
    Tester.add_callback_methods :boot, :exit
    assert_equal [:boot, :exit], Tester.callbacks
  end
  
  def test_callbacks_created_in_class_should_be_vissible_in_instance
    Tester.add_callback_methods :boot, :exit
    t = Tester.new
    assert_equal [:boot, :exit], t.callbacks
  end
  
  def test_callback_created_in_instance_should_not_be_vissible_in_class
    t = Tester.new
    t.add_callback :boot
    assert_equal [], Tester.callbacks
  end
  
end

#Tester.callbacks == [:boot, :exit]
#
#t = Tester.new
#t.callbacks == [:boot, :exit]
#t.add_callbacks :testing
#
#t.boot
#t.testing
#t.exit
#
#t.remove_callbacks :boot
#t.boot