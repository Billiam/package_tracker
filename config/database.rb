Sequel::Model.plugin(:schema)
Sequel::Model.plugin(:timestamps)
Sequel::Model.raise_on_save_failure = false # Do not throw exceptions on failure
Sequel::Model.db =  Sequel.connect(ENV.fetch('DATABASE_URL'),  :loggers => [logger])
