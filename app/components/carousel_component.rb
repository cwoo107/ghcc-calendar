# frozen_string_literal: true

class CarouselComponent < ViewComponent::Base
  def initialize(events:)

    @events = []

    events.each do |event|
      if event.event_details['resources'].nil?
      else
        if event.event_details['resources']['resource'].class == Hash
          if event.event_details['resources']['resource']['name'] == 'Featured Event'
            @events.append(event)
          else
          end
        else
          event.event_details['resources']['resource'].each do |e|
            if e['name'] == 'Featured Event'
              @events.append(event)
            end
          end
        end
      end
    end
  end
end
