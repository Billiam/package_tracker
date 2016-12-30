class Preference < Sequel::Model
  dataset_module do
    def preference_object
      hash = select_hash(:key, :value)
      Struct.new('Preferences', *hash.keys).new(*hash.values)
    end
  end
end
