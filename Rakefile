require 'bundler/setup'
require 'padrino-core/cli/rake'

PadrinoTasks.use(:database)
PadrinoTasks.use(:sequel)

# Suppress load path deprecation in padrino < 0.14
$LOAD_PATH.unshift(File.expand_path('lib'))
PadrinoTasks.init

task :default => :test
