desc "Create VAPID keys"
task :generate_vapid => :environment do
  FindTrackingNumbersWorker.new.perform
  vapid_key = Webpush.generate_key
  puts <<~EOF
    VAPID_PUBLIC_KEY=#{vapid_key.public_key}
    VAPID_PRIVATE_KEY=#{vapid_key.private_key}
  EOF
end
