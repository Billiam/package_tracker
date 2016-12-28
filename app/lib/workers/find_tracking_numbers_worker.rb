class FindTrackingNumbersWorker
  def client
    InboxReader.new(ENV.fetch('GMAIL_USER'), ENV.fetch('GMAIL_PASSWORD'))
  end

  def perform
    EmailTracker.parse_messages(client.messages).each do |(carrier, number)|
      TrackingNumber.find_or_create(carrier: carrier.to_s, number: number)
    end
  end
end
