class TrackingNumber < Sequel::Model
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
