$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'callbacks'

class Tester

  def boot
    return "booting"
  end

  def exit
    return "exiting"
  end

  def testing
    return "testing"
  end
  
  def fill_globalvar_tests_run
    $tests_run << 'fill_globalvar_tests_run'
  end

  include Callbacks
end