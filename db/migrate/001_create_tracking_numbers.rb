Sequel.migration do
  up do
    create_table :tracking_numbers do
      primary_key :id
      String :carrier
      String :number
      String :status
      DateTime :scheduled_for
      DateTime :delivered_at

      DateTime :created_at
      DateTime :updated_at
    end
  end

  down do
    drop_table :tracking_numbers
  end
end
