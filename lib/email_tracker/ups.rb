module EmailTracker::Ups
  BODY_EXPRESSIONS = [
    /\*Tracking Number:\* ([a-zA-Z0-9]{10}\d{8})\b/,
    /Tracking Number:?(?:\s|=C2=AO)([a-zA-Z0-9]{10}\d{8})\b/
  ]
  SUBJECT_EXPRESSIONS = [
    /Tracking Number ([a-zA-Z0-9]{10}\d{8})\b/
  ]

  def self.tracking_data(message)
    return unless message.from.any? {|from| from.host == 'ups.com' && from.mailbox == 'mcinfo' }

    tracking_number = self.find_tracking_number(message)
    [:ups, tracking_number] if tracking_number
  end

  private

  def self.find_tracking_number(message)
    result = BODY_EXPRESSIONS.detect do |expression|
      message.body[expression, 1]
    end
    return result if result

    SUBJECT_EXPRESSIONS.detect do |expression|
      message.subject[expression, 1]
    end
  end
end

EmailTracker.register(EmailTracker::Ups)
