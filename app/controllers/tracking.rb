Trackify::App.controllers :tracking do
  get :index, :map => '/' do
    @active = TrackingNumber.active.order(:scheduled_for)
    @complete = TrackingNumber.recently_delivered.reverse_order(:delivered_at)
    render "tracking/index"
  end
end
