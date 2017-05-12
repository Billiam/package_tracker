Trackify::App.controllers :tracking do
  get :index, :map => '/' do
    @active = TrackingNumber.active.order(:scheduled_for)
    @complete = TrackingNumber.recently_delivered.reverse_order(:delivered_at)
    @mailbox = MailImage.where { created_at > 6.days.ago }.reverse_order(:created_at).group_by_day

    @daily_mail = MailImage.where { created_at > 1.day.ago }.count

    render "tracking/index"
  end
end
