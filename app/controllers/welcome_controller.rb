class WelcomeController < ApplicationController
  def index
    require 'net/http'
    require 'openssl'

    uri = URI('https://goldenhills.ccbchurch.com/api.php?srv=event_profiles&modified_since=2021-01-01&include_image_link=true')

    Net::HTTP.start(uri.host, uri.port,
                    :use_ssl => uri.scheme == 'https',
                    :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

      request = Net::HTTP::Get.new uri.request_uri
      request.basic_auth ENV['USERNAME'], ENV['PASSWORD']

      response = http.request request # Net::HTTPResponse object

      calendar = Nokogiri.XML(response.body)
      calendar = calendar.xpath("//ccb_api//response//events")
      require 'json'
      require 'active_support/core_ext'
      cal = Hash.from_xml(calendar.to_s)
      @calendar = cal

    end

  end
end
