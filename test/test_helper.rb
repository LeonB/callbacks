require 'test/unit'
require 'rubygems'

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'callbacks'

class Tester
  include Callbacks
  add_callbacks :boot, :exit

  def boot
    p "booting"
  end

  def exit
    p "exiting"
  end

  def testing
    p "testing"
  end

end
