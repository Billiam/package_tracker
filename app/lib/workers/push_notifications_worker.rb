require 'oj'

class PushNotificationsWorker
  def perform(changes)
    return unless ENV['VAPID_PUBLIC_KEY'].present? && ENV['VAPID_PRIVATE_KEY'].present?

    Subscription.all.product(changes).each do |subscription, tracking|
      if subscription.interested_in?(tracking)
        notify(subscription, tracking)
      end
    end
  end

  private

  def notify(subscription, package)
    begin
      changes = package.previous_changes
      title = "Package updated"
      if changes
        title = "Package created" if changes.dig(:status, 1).present? && changes.dig(:status, 0).blank?
        title = "Package schedule changed" if changes[:scheduled_for]
        title = "Package delivered" if changes.dig(:delivered_at, 1).present? && changes.dig(:delivered_at, 0).blank?
      end

      Webpush.payload_send(
        message: Oj.dump({
          body: "#{package.carrier}: #{package.number}\n#{package.latest_event}",
          title: title,
          tracking_number: package.number,
          url: '/'
        }, mode: :compat),
        endpoint: subscription.url,
        p256dh: subscription.auth_keys['p256dh'],
        auth: subscription.auth_keys['auth'],
        vapid: {
          subject: ENV.fetch('CONTACT_URL_OR_MAILTO', ''),
          public_key: ENV.fetch('VAPID_PUBLIC_KEY'),
          private_key: ENV.fetch('VAPID_PRIVATE_KEY')
        }
      )
    rescue Webpush::InvalidSubscription => e
      subscription.delete
    end
  end
end
