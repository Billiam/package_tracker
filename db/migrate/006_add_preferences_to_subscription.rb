Sequel.migration do
  up do
    alter_table :subscriptions do
      add_column :notify_all, TrueClass
      add_column :notify_new, TrueClass
      add_column :notify_scheduled, TrueClass
      add_column :notify_delivered, TrueClass
    end
  end

  down do
    alter_table :subscriptions do
      drop_column :notify_all
      drop_column :notify_delivered
      drop_column :notify_scheduled
      drop_column :notify_new
    end
  end
end
