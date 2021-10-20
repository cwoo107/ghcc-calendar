class UpdateEventsJob < ApplicationJob
  queue_as :default

  def perform(*backfill)
    require 'net/http'
    require 'openssl'

    if backfill.present?
      date = backfill[0]
    else
      date = "#{Date.today.year}-#{Date.today.month}-#{Date.today.day}"
    end
    uri = URI("https://goldenhills.ccbchurch.com/api.php?srv=event_profiles&modified_since=#{date}&include_image_link=true")
    Net::HTTP.start(uri.host, uri.port,
                    :use_ssl => uri.scheme == 'https',
                    :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

      request = Net::HTTP::Get.new uri.request_uri
      request.basic_auth "JoshFelise",  "Jpf859675!"

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
end
