Sequel.migration do
  up do
    create_table :subscriptions do
      primary_key :id
      String :url
      jsonb :auth_keys

      DateTime :created_at
      DateTime :updated_at
    end
  end

  down do
    drop_table :subscriptions
  end
end
