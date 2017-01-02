require 'oj'

Trackify::App.controllers :subscribe, :provides => [:json] do
  post :create, map: '/subscription', :csrf_protection => false, params: [subscriber: [:endpoint, :keys] , preferences: Subscription::PREFERENCES] do
    subscriber_params = params[:subscriber]

    unless subscriber_params[:endpoint].present? && subscriber_params[:keys].present?
      status 422
      return '{"error": "Required subscription data is invalid or missing"}'
    end

    preferences = params[:preferences] || {}

    if preferences.values.none?
      Subscription.where(url: subscriber_params[:endpoint]).destroy
      return '{"status": "success", "message": "Deleted subscription"}'
    else
      Subscription.update_or_create(url: subscriber_params[:endpoint]) do |subscription|
        subscription.auth_keys = Sequel.pg_jsonb(subscriber_params[:keys])
        Subscription::PREFERENCES.each do |preference|
          subscription[preference] = preferences[preference.to_s] === true
        end
      end

      '{"status": "success", "message": "Updated subscription"}'
    end
  end

  get :show, map: '/subscription' do
    url = params[:subscriber][:url]

    existing_subscription = Subscription.find(url: url)
    unless existing_subscription
      status 404
      return '{"status": "No subscription found"}'
    end

    Oj.dump({
      notify_all: existing_subscription.notify_all?,
      notify_new: existing_subscription.notify_new?,
      notify_scheduled: existing_subscription.notify_scheduled?,
      notify_delivered: existing_subscription.notify_delivered?
    }, mode: :compat)
  end
end
