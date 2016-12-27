module EmailTracker::Ups
  def self.tracking_data(message)
    return unless message.from.any? {|from| from.host == 'ups.com' && from.mailbox == 'mcinfo' }

    match = /\*Tracking Number:\* ([a-zA-Z0-9]{10}\d{8})\b/.match(message.body)
    [:ups, match[1]] if match
  end
end

EmailTracker.register(EmailTracker::Ups)
