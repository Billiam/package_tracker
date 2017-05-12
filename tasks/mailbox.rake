desc "Poll an inbox for new tracking numbers"
task :read_mailbox => :environment do
  FindTrackingNumbersWorker.new.perform
end

desc "Read USPS Informed Delivery images"
task :read_usps_mail => :environment do
  ReadMailboxWorker.new.perform
end
