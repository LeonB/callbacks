class SingletonCallbacksTest < Test::Unit::TestCase
  attr_accessor :tester
  
  def setup
    Object.send(:remove_const, :Tester) if defined? Tester
    load 'test/tester_class.rb'
    self.tester = Tester.new
    $tests_run = []
  end
  
  def test_should_create_instance_methods
    tester.metaclass.add_callback_methods :boot
    
    assert_nothing_raised { tester.boot }
    assert_nothing_raised { tester.boot_without_callbacks }
    assert_nothing_raised { tester.metaclass.before_boot('p "ehlo"') }
    assert_nothing_raised { tester.metaclass.after_boot('p "ehlo"') }
  end
  
  def test_class_should_create_before_and_after_method
    tester.metaclass.add_callback_methods :boot
    methods = tester.metaclass.methods.grep(/(^before_.+$|^after_.+$)/)
    
    assert methods.include?('before_boot')
    assert methods.include?('after_boot')
  end
  
  def test_callback_created_in_instance_should_not_be_vissible_in_class
    tester.metaclass.add_callback_methods :boot
    assert_equal [], Tester.callback_methods
  end
    
  def test_callback_created_in_class_should_be_vissible_in_instance
    #This ain't gonna work...
    #I don't know how to get the variables
    Tester.add_callback_methods :boot
    t = Tester.new
    assert_equal [:boot], t.metaclass.callback_methods
  end
    
  def test_callbacks_created_in_class_and_instance_should_both_be_run
    Tester.add_callback_methods :boot
    Tester.before_boot do
      $tests_run << 'before_boot'
    end
      
    tester.metaclass.after_boot do
      $tests_run << 'after_boot'
    end
      
    tester.boot
      
    assert $tests_run.include?('before_boot')
    assert $tests_run.include?('after_boot')
  end
  
  def test_callbacks_created_in_class_and_instance_should_both_be_run_2
    Tester.add_callback_methods :boot
    Tester.before_boot do
      $tests_run << 'before_boot'
    end
      
    tester.metaclass.before_boot do
      $tests_run << 'before_boot_2'
    end
      
    tester.boot
      
    assert $tests_run.include?('before_boot')
    assert $tests_run.include?('before_boot_2')
  end
  
  def test_singleton_callbacks_on_clean_object
    a = Object.new
    a.metaclass.send(:include, Callbacks)
    a.metaclass.add_callback_methods :to_s
    a.metaclass.before_to_s do
      $tests_run << 'clean!'
    end
    a.to_s #and see the magic happen
    
    assert $tests_run.length == 1
    assert $tests_run[0] == 'clean!'
  end
end