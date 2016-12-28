desc "Update active tracking data"
task :update_tracking => :environment do
  UpdateTrackingWorker.new.perform
end
