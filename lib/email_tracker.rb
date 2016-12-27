module EmailTracker
  class << self
    def trackers
      @trackers ||= []
    end

    def register(tracker)
      self.trackers << tracker
    end

    def identify(message)
      trackers.each do |tracker|
        result = tracker.tracking_data(message)

        return result if result
      end

      nil
    end

    def process(messages)
      Array(messages).map do |message|
        identify(message)
      end.compact
    end
  end
end
