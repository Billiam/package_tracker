class Preference < Sequel::Model
  dataset_module do
    def preference_object
      hash = select_hash(:key, :value)
      Struct.new('Preferences', *hash.keys).new(*hash.values)
    end
  end
end

# Table: preferences
# Columns:
#  id          | integer | PRIMARY KEY DEFAULT nextval('preferences_id_seq'::regclass)
#  key         | text    |
#  value       | text    |
#  description | text    |
# Indexes:
#  preferences_pkey | PRIMARY KEY btree (id)
