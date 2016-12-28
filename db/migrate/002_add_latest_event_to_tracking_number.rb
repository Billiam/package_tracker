Sequel.migration do
  up do
    alter_table :tracking_numbers do
      add_column :latest_event, String
    end
  end

  down do
    alter_table :tracking_numbers do
      drop_column :latest_event
    end
  end
end
