Sequel.migration do
  up do
    create_table :preferences do
      primary_key :id
      String :key
      String :value
      String :description
    end
  end

  down do
    drop_table :preferences
  end
end
