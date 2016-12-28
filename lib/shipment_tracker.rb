module ShipmentTracker
  CLIENTS = {
    ups: ActiveShipping::UPS.new(
      login: ENV.fetch('UPS_LOGIN'),
      password: ENV.fetch('UPS_PASSWORD'),
      key: ENV.fetch('UPS_KEY')
    ),

    fedex: ActiveShipping::FedEx.new(
      login: ENV.fetch('FEDEX_LOGIN'),
      password: ENV.fetch('FEDEX_PASSWORD'),
      key: ENV.fetch('FEDEX_KEY'),
      account: ENV.fetch('FEDEX_ACCOUNT'),
      test: ENV.fetch('FEDEX_TEST', 'false') == 'true'
    ),

    usps: ActiveShipping::USPS.new(
      login: ENV.fetch('USPS_LOGIN')
    ),

  }

  CLIENTS.each do |name, client|
    define_singleton_method(name) do
      client
    end
  end

  def self.[](key)
    CLIENTS[key]
  end
end
