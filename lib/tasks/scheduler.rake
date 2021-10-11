desc "This task is called by the Heroku scheduler add-on"

task :update_events => :environment do
  UpdateEventsJob.perform_now
end