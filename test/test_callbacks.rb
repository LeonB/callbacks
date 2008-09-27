class CallbacksTest < Test::Unit::TestCase
  
  def setup
    Object.send(:remove_const, :Tester)  if defined? Tester
    load 'test/tester_class.rb'
    $tests_run = []
  end
  
  def test_class_should_return_values
    t = Tester.new
    assert_equal 'booting', t.boot
    assert_equal 'exiting', t.exit
  end
  
  def test_should_create_methods_in_class
    Tester.add_callback_methods :boot
    
    assert_nothing_raised { Tester.new.boot }
    assert_nothing_raised { Tester.new.boot_without_callbacks }
    assert_nothing_raised { Tester.before_boot('p "ehlo"') }
    assert_nothing_raised { Tester.after_boot('p "ehlo"') }
  end
  
  def test_remove_callback
    Tester.add_callback_methods :boot, :exit
    Tester.remove_callback_method :boot
    Tester.remove_callback_method :exit
    
    assert_equal [], Tester.callback_methods
    assert_raise(NoMethodError) { Tester.before_boot }
    assert_raise(NoMethodError) { Tester.after_boot }
    
  end
  
  def test_should_create_callback_methods_in_class
    Tester.add_callback_methods :boot, :exit
    assert_equal [:boot, :exit], Tester.callback_methods
  end
  
  def test_class_should_create_before_and_after_method
    Tester.add_callback_methods :boot
    methods = Tester.methods.grep(/(^before_.+$|^after_.+$)/)
    
    assert methods.include?('before_boot')
    assert methods.include?('after_boot')
  end
  
  def test_class_callbacks_should_run_callbacks
    Tester.add_callback_methods :boot, :exit
    
    Tester.before_boot do
      $tests_run << 'before_boot'
    end
    
    Tester.after_exit do
      $tests_run << 'after_exit'
    end
    
    t = Tester.new
    assert_equal 'booting', t.boot
    assert $tests_run.include?('before_boot')
    
    assert_equal 'exiting', t.exit
    assert $tests_run.include?('after_exit')
  end
  
  def test_class_callbacks_should_run_symbol
    Tester.add_callback_methods :exit
    Tester.before_exit :fill_globalvar_tests_run
    t = Tester.new
    t.exit
    
    assert_equal 'fill_globalvar_tests_run', $tests_run.first
  end
  
  def test_class_callbacks_should_run_block_in_self
    Tester.add_callback_methods :exit
    
    Tester.before_exit do
      $tests_run << self.boot
    end
    
    t = Tester.new
    assert_equal 'exiting', t.exit
    
    assert_equal 'booting', $tests_run.first
  end
  
  def test_class_callbacks_should_run_string
    Tester.add_callback_methods :boot
    Tester.after_boot '$tests_run << "after_test"'
    t = Tester.new
    t.boot
    
    assert_equal 'after_test', $tests_run.first
  end
  
  def test_class_callbacks_should_run_method
    
  end
  
  def test_class_callbacks_should_raise_when_wrong_argument
    
  end
  
  def test_class_without_actions_should_not_give_exception
    Tester.add_callback_methods :boot, :exit
    t = Tester.new
    assert_nothing_raised do 
      t.boot
    end
  end
  
  def test_class_without_actions_should_return_original_retval
    Tester.add_callback_methods :boot, :exit
    t = Tester.new
    assert_equal 'booting', t.boot
  end
  
  def test_callback_methods_of_two_classes_should_be_kept_seperate
    tester_two_class = Tester.dup
    tester_three_class = Tester.dup
    Tester.add_callback_methods :exit
    tester_two_class.add_callback_methods :boot
    
    assert_equal [], tester_three_class.callback_methods
    assert_equal [:exit], Tester.callback_methods
    assert_equal [:boot], tester_two_class.callback_methods
    
  end
  
  def test_callback_actions_of_two_classes_should_be_kept_seperate
    Tester.add_callback_methods :exit
    tester_two_class = Tester.dup
    tester_three_class = Tester.dup
    
    tester_two_class.before_exit do
      $tests_run << 'before_exit'
    end
    
    Tester.after_exit do
      $tests_run << 'after_exit'
    end

    assert_equal({}, tester_three_class.callback_actions)
    
    Tester.new.exit
    assert_equal ['after_exit'], $tests_run
    
    $tests_run = []
    
    tester_two_class.new.exit
    assert_equal ['before_exit'], $tests_run
  end
  
  def test_add_no_method_callback
    assert_nothing_raised do 
      Tester.add_callback_method :doesnotexist
    end
  end
  
  def test_no_method_callback_should_not_add_method
    Tester.add_callback_method :nomethodcallback
    
    assert_raise do 
      t = Tester.new
      t.nomethodcallback
    end
  end
  
  #  def test_callbacks_created_in_class_should_be_vissible_in_instance
  #    Tester.add_callback_methods :boot, :exit
  #    t = Tester.new
  #    assert_equal [:boot, :exit], t.callbacks
  #  end
  
  #  def test_callback_created_in_instance_should_not_be_vissible_in_class
  #    t = Tester.new
  #    t.add_callback :boot
  #    assert_equal [], Tester.callbacks
  #  end
  
end