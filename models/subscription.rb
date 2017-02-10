class Subscription < Sequel::Model
  plugin :validation_helpers

  PREFERENCES = %I[notify_all notify_new notify_scheduled notify_delivered]

  def validate
    super
    validates_presence [:keys, :url]
  end

  def interested_in?(tracking)
    return true if notify_all?

    if tracking.just_created?
      return notify_new?
    end

    return true if tracking.just_delivered? && notify_delivered?
    return true if tracking.changed_schedule? && notify_scheduled?

    false
  end

  PREFERENCES.each do |column|
    define_method("#{column}?") do
      self.public_send(column)
    end
  end
end

# Table: subscriptions
# Columns:
#  id               | integer                     | PRIMARY KEY DEFAULT nextval('subscriptions_id_seq'::regclass)
#  url              | text                        |
#  auth_keys        | jsonb                       |
#  created_at       | timestamp without time zone |
#  updated_at       | timestamp without time zone |
#  notify_all       | boolean                     |
#  notify_new       | boolean                     |
#  notify_scheduled | boolean                     |
#  notify_delivered | boolean                     |
# Indexes:
#  subscriptions_pkey | PRIMARY KEY btree (id)
