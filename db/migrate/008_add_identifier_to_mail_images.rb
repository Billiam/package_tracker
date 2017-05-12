Sequel.migration do
  up do
    alter_table :mail_images do
      add_column :identifier, String, unique: true
    end
  end

  down do
    alter_table :mail_images do
      drop_column :identifier
    end
  end
end
