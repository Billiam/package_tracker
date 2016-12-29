Trackify::App.helpers do
  def tracking_url(carrier, number)
    case carrier
      when :ups
        "http://wwwapps.ups.com/WebTracking/track?track=yes&trackNums=#{number}"
      when :usps
        "https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=#{number}"
      when :fedex
        "http://www.fedex.com/Tracking?action=track&tracknumbers=#{number}"
      else
        ''
    end
  end
end
