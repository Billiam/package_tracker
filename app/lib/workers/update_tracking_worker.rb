class UpdateTrackingWorker
  def client
    InboxReader.new(ENV.fetch('GMAIL_USER'), ENV.fetch('GMAIL_PASSWORD'))
  end

  def perform
    TrackingNumber.active.each do |item|
      begin
        tracking_data = ShipmentTracker[item.carrier.to_sym].find_tracking_info item.number
      rescue ActiveShipping::ShipmentNotFound => e
        next
      end

      # :status, :status_code, :destination, :origin, :carrier, :carrier_name, :status_description, :ship_time, :scheduled_delivery_date, :actual_delivery_date, :attempted_delivery_date, :delivery_signature, :tracking_number, :shipment_events, :shipper_address, :latest_event, :is_delivered?, :has_exception?, :exception_event, :delivered?, :exception?, :scheduled_delivery_time, :actual_delivery_time, :attempted_delivery_time, :message, :success?, :xml, :test, :request, :params, :test?]
      item.status = tracking_data.status
      # rescheduled_date = tracking_data.params.dig('Shipment', 'Package', 'RescheduledDeliveryDate')
      # if rescheduled_date
      #   parse_date if ups
      # else
      item.scheduled_for = Time.zone.local_to_utc(tracking_data.scheduled_delivery_time.to_time) if tracking_data.scheduled_delivery_time

      # end

      item.delivered_at = Time.zone.local_to_utc(tracking_data.actual_delivery_time.to_time) if tracking_data.actual_delivery_time
      item.latest_event = tracking_data.message
      last_event = tracking_data.shipment_events.last
      if last_event
        time = Time.zone.local_to_utc(last_event.time).strftime("%a, %b %e at %R")
        item.latest_event = "#{last_event.message} #{time} - #{last_event.location}"
      else
        item.latest_event = tracking_data.message
      end

      item.raise_on_save_failure = false
      item.save if item.changed_columns.any?
    end
  end
end
