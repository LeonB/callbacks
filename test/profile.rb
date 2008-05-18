$: << '../lib'
$: << 'lib'
$: << 'test'
require 'tester_class.rb'

Tester.add_callback_methods :boot, :exit
Tester.before_boot do
  p 'before boot'
end

Tester.after_boot 'p "after_boot"'

Tester.after_exit Proc.new {self.test}

t = Tester.new
p t.boot
