class CallbacksTest < Test::Unit::TestCase
  def test_should_create_callback_accessor
    Vehicle.callback :before_enter
    assert Vehicle.respond_to?(:before_enter)
  end
end

Tester.callbacks == [:boot, :exit]

t = Tester.new
t.callbacks == [:boot, :exit]
t.add_callbacks :testing

t.boot
t.testing
t.exit

t.remove_callbacks :boot
t.boot
