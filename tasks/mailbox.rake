desc "Poll an inbox for new tracking numbers"
task :read_mailbox => :environment do
  FindTrackingNumbersWorker.new.perform
end
