Sequel.migration do
  up do
    create_table :mail_images do
      primary_key :id

      String :photo
      DateTime :created_at
    end
  end

  down do
    drop_table :mail_images
  end
end
