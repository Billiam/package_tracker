# Helper methods defined here can be accessed in any controller or view in the application

module Trackify
  class App
    module SubscribeHelper
      def notification_enabled?
        ENV['VAPID_PUBLIC_KEY'].present? && ENV['VAPID_PRIVATE_KEY'].present?
      end
    end

    helpers SubscribeHelper
  end
end
