# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

load 'tasks/setup.rb'

ensure_in_path 'lib'
require 'callbacks'

task :default => 'spec:run'

PROJ.name = 'callbacks'
PROJ.authors = 'Leon Bogaert'
PROJ.email = 'leon@vanutsteen.nl'
PROJ.url = 'www.vanutsteen.nl'
PROJ.rubyforge.name = 'callbacks'
PROJ.version = File.read('Version.txt').strip
PROJ.exclude = %w(.git pkg nbproject doc/)

PROJ.spec.opts << '--color'

# EOF
