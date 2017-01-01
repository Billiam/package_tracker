class Subscription < Sequel::Model
  plugin :validation_helpers

  def validate
    super
    validates_presence [:keys, :url]
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
