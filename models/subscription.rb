class Subscription < Sequel::Model
  plugin :validation_helpers

  def validate
    super
    validates_presence [:keys, :url]
  end

  def notify_delivered?
    true
  end

  def notify_all_updates?
    true
  end

  def notify_estimate_date?
    true
  end

  def notify_new?
    true
  end

  def interested_in?(tracking)
    return true if notify_all_updates?

    if tracking.previous_changes == null
      return notify_new?
    end

    return true if tracking.previous_changes[:delivered_at] && notify_delivered?
    return true if tracking.previous_changes[:scheduled_for] && notify_estimate_date?

    false
  end
end

# Table: subscriptions
# Columns:
#  id         | integer                     | PRIMARY KEY DEFAULT nextval('subscriptions_id_seq'::regclass)
#  url        | text                        |
#  auth_keys  | jsonb                       |
#  created_at | timestamp without time zone |
#  updated_at | timestamp without time zone |
# Indexes:
#  subscriptions_pkey | PRIMARY KEY btree (id)
