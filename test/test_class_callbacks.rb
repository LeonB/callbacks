class ClassCallbacksTest < Test::Unit::TestCase
  attr_accessor :tester
  
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
end