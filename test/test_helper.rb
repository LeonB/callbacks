require 'test/unit'
require 'rubygems'

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'callbacks'

class Tester

  def boot
    p "booting"
  end

  def exit
    p "exiting"
  end

  def testing
    p "testing"
  end

  include Callbacks
end
