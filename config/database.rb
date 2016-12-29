Sequel.datetime_class = DateTime
Sequel.application_timezone = :local
Sequel.database_timezone = :utc

Sequel::Model.plugin(:schema)
Sequel::Model.plugin(:timestamps)
Sequel::Model.raise_on_save_failure = false # Do not throw exceptions on failure
Sequel::Model.db = Sequel.connect(ENV.fetch('DATABASE_URL'), :loggers => [logger])
Sequel::Model.db.extension(:connection_validator)


