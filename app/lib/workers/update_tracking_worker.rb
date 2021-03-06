class UpdateTrackingWorker
  def perform
    updated_records = TrackingNumber.active.map do |item|
      begin
        tracking_data = tracker[item.carrier.to_sym].find_tracking_info item.number
      rescue ActiveShipping::ShipmentNotFound => e
        next
      end

      # :status, :status_code, :destination, :origin, :carrier, :carrier_name, :status_description, :ship_time, :scheduled_delivery_date, :actual_delivery_date, :attempted_delivery_date, :delivery_signature, :tracking_number, :shipment_events, :shipper_address, :latest_event, :is_delivered?, :has_exception?, :exception_event, :delivered?, :exception?, :scheduled_delivery_time, :actual_delivery_time, :attempted_delivery_time, :message, :success?, :xml, :test, :request, :params, :test?]
      item.status = tracking_data.status
      # rescheduled_date = tracking_data.params.dig('Shipment', 'Package', 'RescheduledDeliveryDate')
      # if rescheduled_date
      #   parse_date if ups
      # else
      item.scheduled_for = local_time(tracking_data.scheduled_delivery_time) if tracking_data.scheduled_delivery_time
      # end

      item.delivered_at = local_time(tracking_data.actual_delivery_time) if tracking_data.actual_delivery_time
      last_event = tracking_data.shipment_events.last

      if last_event
        time = local_time(last_event.time).strftime("%a, %b %e at %R")
        item.latest_event = "#{last_event.message} #{time} - #{last_event.location}"
      else
        item.latest_event = tracking_data.message
      end

      item.raise_on_save_failure = false

      item.save_changes
    end.compact

    PushNotificationsWorker.new.perform(updated_records) if updated_records.any?
  end

  private

  def tracker
    @tracker ||= ShipmentTracker.new
  end

  def local_time(time)
    Time.zone.local_to_utc(time.to_time.utc)
  end
end
