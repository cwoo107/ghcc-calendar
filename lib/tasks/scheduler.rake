desc "This task is called by the Heroku scheduler add-on"

task :update_events => :environment do
  if ENV['BACKFILL'] = 'true'
  UpdateEventsJob.perform_now(ENV['BACKFILL_DATE'])
  else
    UpdateEventsJob.perform_now
  end
end