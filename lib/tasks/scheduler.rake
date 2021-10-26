desc "This task is called by the Heroku scheduler add-on"

task :update_events => :environment do
  if ENV['BACKFILL'] == 'true'
  UpdateEventsJob.perform_now(ENV['BACKFILL_DATE'])
  else
    UpdateEventsJob.perform_now
  end
end

task :delete_events => :environment do
  Event.delete_all
end

task :add_all_events => :environment do
  require 'net/http'
  require 'openssl'

  uri = URI("https://goldenhills.ccbchurch.com/api.php?srv=event_profiles&modified_since=2018-01-01&include_image_link=true")
  Net::HTTP.start(uri.host, uri.port,
                  :use_ssl => uri.scheme == 'https',
                  :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

    request = Net::HTTP::Get.new uri.request_uri
    request.basic_auth ENV['USERNAME'],  ENV['PASSWORD']

    response = http.request request # Net::HTTPResponse object

    calendar = Nokogiri.XML(response.body)
    calendar = calendar.xpath("//ccb_api//response//events")
    require 'json'
    require 'active_support/core_ext'
    cal = Hash.from_xml(calendar.to_xml).to_json

    @calendar = JSON.parse(cal)
    @calendar['events']['event'].each do |cal|
      Event.where(id: cal['id']).
        first_or_create(id: cal['id'], event_details: cal).
        update(event_details: cal)
    end
  end
end
