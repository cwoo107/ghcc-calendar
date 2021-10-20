# frozen_string_literal: true

class ListComponent < ViewComponent::Base
  def initialize(events:)
    @events = []
    events.each do |event|
      if event.event_details['resources'].nil?
      else
        if event.event_details['resources']['resource'].class == Hash
          if event.event_details['resources']['resource']['name'] == 'Featured Event' && event.event_details['resources']['resource']['status'] == 'Approved'
            @events.append(event)
          elsif event.event_details['resources']['resource']['name'] == 'Reoccurring Events'
            @events.append(event)
          else
          end
        else
          event.event_details['resources']['resource'].each do |e|
            if e['name'] == 'Featured Event' && e['status'] == 'Approved'
              @events.append(event)
            elsif e['name'] == 'Reoccurring Events'
              @events.append(event)
            end
          end
        end
      end
    end
  end
end
