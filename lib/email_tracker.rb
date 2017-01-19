module EmailTracker
  class << self
    def trackers
      @trackers ||= []
    end

    def register(tracker)
      self.trackers << tracker
    end

    def parse_message(message)
      trackers.each do |tracker|
        result = tracker.tracking_data(message)

        return result if result
      end

      Padrino.logger.warn "Could not parse email: #{message.subject}"

      nil
    end

    def parse_messages(messages)
      Array(messages).map do |message|
        parse_message(message)
      end.compact
    end
  end
end
