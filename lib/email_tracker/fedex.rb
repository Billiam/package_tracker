module EmailTracker::Fedex
  def self.tracking_data(message)
    return unless message.from.any? { |from| from.host == 'fedex.com.com' && from.mailbox == 'TrackingUpdates' }

    match = /\*Tracking number:\* (\d{12,22})\b/.match(message.body)
    [:fedex, match[1]] if match
  end
end

EmailTracker.register(EmailTracker::Fedex)
