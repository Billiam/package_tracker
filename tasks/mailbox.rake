task :read_mailbox => :environment do
  FindTrackingNumbersWorker.new.perform
end
