if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    return unless forked

    ::Sequel::DATABASES.each(&:disconnect)
  end
end
