Trackify::App.controllers :subscribe, :provides => [:json] do
  post :create, map: '/subscription', :csrf_protection => false, params: [subscriber: [:endpoint, :keys]]  do
    subscriber_params = params[:subscriber]

    unless subscriber_params[:endpoint].present? && subscriber_params[:keys].present?
      status 422
      return '{"error": "Required subscription data is invalid or missing"}'
    end

    subscription = Subscription.find_or_create(url: subscriber_params[:endpoint]) do |subscription|
      subscription.auth_keys = Sequel.pg_jsonb(subscriber_params[:keys])
    end

    if (subscription.save rescue false)
      return '{"status": "success"}'
    else
      return '{"status": "failed"}'
    end
  end
end
