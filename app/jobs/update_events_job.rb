class UpdateEventsJob < ApplicationJob
  queue_as :default

  def perform
    require 'net/http'
    require 'openssl'

    uri = URI("https://goldenhills.ccbchurch.com/api.php?srv=event_profiles&modified_since=#{Date.today.year}-#{Date.today.month - 1.month}-#{Date.today.day}&include_image_link=true")

    Net::HTTP.start(uri.host, uri.port,
                    :use_ssl => uri.scheme == 'https',
                    :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

      request = Net::HTTP::Get.new uri.request_uri
      request.basic_auth ENV["USERNAME"],  ENV["PASSWORD"]

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
