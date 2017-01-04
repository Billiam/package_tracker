module EmailTracker::Usps
  def self.tracking_data(message)
    return unless message.from.any? {|from| from.host == 'usps.com' }

    match = /Tracking Number: (\d{20,26})\b/.match(message.body)
    [:usps, match[1]] if match
  end
end

EmailTracker.register(EmailTracker::Usps)
