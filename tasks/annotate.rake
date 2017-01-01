desc "Update model annotations"
task :annotate => :environment do
  require 'sequel/annotate'
  Sequel::Annotate.annotate(Dir['models/*.rb'])
end
