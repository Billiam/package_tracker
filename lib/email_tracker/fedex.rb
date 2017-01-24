module EmailTracker::Fedex
  def self.tracking_data(message)
    return unless message.from.any? { |from| from.host == 'fedex.com' && from.mailbox == 'TrackingUpdates' }

    match = /\*Tracking number:\* (\d{12,22})\b/.match(message.body)
    match = /tracknumbers=(\d{12,22})\b/.match(message.body) unless match
    match = /FedEx Shipment (\d{12,22})\b/.match(message.subject) unless match

    [:fedex, match[1]] if match
  end
end

EmailTracker.register(EmailTracker::Fedex)
