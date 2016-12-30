class FindTrackingNumbersWorker
  def perform
    EmailTracker.parse_messages(client.messages).each do |(carrier, number)|
      TrackingNumber.find_or_create(carrier: carrier.to_s, number: number)
    end
  end

  private

  def client
    InboxReader.new(credentials.GMAIL_USER, credentials.GMAIL_PASSWORD)
  end

  def credentials
    @credentials ||= Preference.prefence_object
  end
end
