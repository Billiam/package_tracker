class ShipmentTracker
  CLIENTS = [:ups, :fedex, :usps]

  def self.available_clients
    CLIENTS
  end

  def ups
    ActiveShipping::UPS.new(
      login: credentials.UPS_LOGIN,
      password: credentials.UPS_PASSWORD,
      key: credentials.UPS_KEY
    )
  end

  def fedex
    ActiveShipping::FedEx.new(
      login: credentials.FEDEX_LOGIN,
      password: credentials.FEDEX_PASSWORD,
      key: credentials.FEDEX_KEY,
      account: credentials.FEDEX_ACCOUNT,
      test: credentials.FEDEX_TEST == 'true'
    )
  end

  def usps
    ActiveShipping::USPS.new(
      login: credentials.USPS_LOGIN
    )
  end

  def [](key)
    self.public_send(key) if CLIENTS.include? key
  end

  private

  def credentials
    @credentials ||= Preference.preference_object
  end
end
