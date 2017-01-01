class TrackingNumber < Sequel::Model
  plugin :validation_helpers
  dataset_module do
    def active
      exclude(Sequel.~(status: nil) &  {status: 'delivered'})
    end

    def complete
      where(status: 'delivered')
    end

    def recently_delivered
      where { delivered_at > 6.days.ago }
    end
  end

  def validate
    super
    validates_presence [:number, :carrier]
    validates_includes ShipmentTracker.available_clients.map(&:to_s), :carrier
  end

  def date
    delivered_at || scheduled_for
  end

  def last_updated
    updated_at || created_at
  end

  def scheduled?
    scheduled_for && !delivered_at
  end
end

# Table: tracking_numbers
# Columns:
#  id            | integer                     | PRIMARY KEY DEFAULT nextval('tracking_numbers_id_seq'::regclass)
#  carrier       | text                        |
#  number        | text                        |
#  status        | text                        |
#  scheduled_for | timestamp without time zone |
#  delivered_at  | timestamp without time zone |
#  created_at    | timestamp without time zone |
#  updated_at    | timestamp without time zone |
#  latest_event  | text                        |
# Indexes:
#  tracking_numbers_pkey | PRIMARY KEY btree (id)
