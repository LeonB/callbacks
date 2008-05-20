callbacks
    by Leon Bogaert
    http://github.com/LeonB/callbacks
    http://callbacks.rubyforge.com
    http://www.vanutsteen.nl

== DESCRIPTION:

This package makes it simple to add callbacks a.k.a. "hooks" to ruby classes

== FEATURES/PROBLEMS:

* It now only supports adding callbacks to classes
* Different callbacks for instances comes with version 0.2
* I haven't decided yet on the API, maybe I'll swap "callback_methods" with "hooks"

== SYNOPSIS:

    require 'callbacks'

    Object.send(:include, Callbacks)
    Object.add_callback_methods :inspect
    Object.before_inspect do
    print "Going to inspect #{self.class}\n"
    end

    o = Object.new
    o.inspect #will print "Going to inspect Object"

== REQUIREMENTS:

* ruby 1.8 (might work with ruby1.9)

== INSTALL:

* gem install callbacks

== THANKS:
    * RDoc [http://www.ruby-doc.org/core/classes/RDoc.html]
    * Bones [http://codeforpeople.rubyforge.org/bones]

== LICENSE:

(The MIT License)

Copyright (c) 2008

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
